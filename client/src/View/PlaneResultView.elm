module View.PlaneResultView exposing (view)

import Html exposing (Html, caption, div, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, id, scope)
import Models exposing (GeometryParam, GeometryParamType, GeometryType, Model)
import View.Navigator exposing (navbar)
import View.RandomPoints3DView as RandomPoints3DView


view : Model -> Html msg
view model =
    div [ id "plane-result-view" ]
        [ navbar
        , RandomPoints3DView.view captionText model.randomPlanePoints
        ]


captionText : String
captionText =
    "The randomly created plane points"
