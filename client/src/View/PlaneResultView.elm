module View.PlaneResultView exposing (view)

import Html exposing (Html, caption, div, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, id, scope)
import Models exposing (GeometryParam, Model, getParamTypeName)
import Selectors exposing (hasPlaneFormError)
import View.Navigator exposing (navbar)
import View.RandomPoints3DView as RandomPoints3DView


view : Model -> Html msg
view model =
    let
        planeParams =
            model.planeParameters

        caption =
            captionText planeParams
    in
    div [ id "plane-result-view" ]
        [ navbar
        , RandomPoints3DView.view caption model.randomPlanePoints
        ]


captionText : List GeometryParam -> String
captionText planeParams =
    let
        isPlaneValid =
            not (hasPlaneFormError planeParams)

        parseParam =
            \param ->
                ", "
                    |> (++) param.value
                    |> (++) "="
                    |> (++) (getParamTypeName param.paramType)

        paramsFormatted =
            planeParams
                |> List.filter (\param -> not (param.paramType == Models.PointCount))
                |> List.map parseParam
                |> List.reverse
                |> List.foldl (++) ""
                |> String.dropRight 2
    in
    case isPlaneValid of
        True ->
            """The randomly created plane points. The plane definition was: """ ++ paramsFormatted

        False ->
            ""
