module View.RandomPoints3DView exposing (view)

import Html exposing (Html, button, caption, div, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (attribute, class, id, property, scope, title)
import Models exposing (Point3D)
import RemoteData exposing (WebData)
import Round
import String exposing (fromInt)


view : String -> WebData (List Point3D) -> Html msg
view captionText randomPointsResult =
    let
        randomPoints =
            case randomPointsResult of
                RemoteData.Success points ->
                    points

                _ ->
                    []

        parsePointForClipboard =
            \param ->
                roundCoordinate param.x ++ "\t" ++ roundCoordinate param.y ++ "\t" ++ roundCoordinate param.z ++ "\n"

        copyToClipboardText =
            randomPoints
                |> List.map parsePointForClipboard
                |> List.foldr (++) ""
    in
    div [ class "container-fluid" ]
        [ div [ class "row mt-2" ]
            [ div [ class "col-lg-2" ] []
            , div [ class "col-lg-8" ]
                [ buttonCopyToClipboard copyToClipboardText
                , resultTable captionText randomPoints
                ]
            , div [ class "col-lg-2" ] []
            ]
        ]


resultTable : String -> List Point3D -> Html msg
resultTable captionText randomPoints =
    div [ class "table-responsive table-sm" ]
        [ table [ class "table" ]
            [ tableCaption captionText
            , tableHead
            , tableBody randomPoints
            ]
        ]


tableCaption : String -> Html msg
tableCaption captionText =
    caption [] [ text captionText ]


tableHead : Html msg
tableHead =
    thead []
        [ tr []
            [ th [ scope "col" ] [ text "#" ]
            , th [ scope "col" ] [ text "x" ]
            , th [ scope "col" ] [ text "y" ]
            , th [ scope "col" ] [ text "z" ]
            ]
        ]


tableBody : List Point3D -> Html msg
tableBody randomPoints =
    let
        rows =
            randomPoints
                |> List.indexedMap tableRow
    in
    tbody [] rows


tableRow : Int -> Point3D -> Html msg
tableRow index randomPoint =
    tr []
        [ th [] [ text (fromInt (index + 1)) ]
        , td [] [ text (roundCoordinate randomPoint.x) ]
        , td [] [ text (roundCoordinate randomPoint.y) ]
        , td [] [ text (roundCoordinate randomPoint.z) ]
        ]


buttonCopyToClipboard : String -> Html msg
buttonCopyToClipboard copyText =
    div [ class "d-flex flex-row-reverse" ]
        [ button
            [ class "btn btn-outline-secondary fas fa-copy m-1"
            , title "copy to clipboard"
            , attribute "data-clipboard-text" copyText
            ]
            []
        ]


roundCoordinate : Float -> String
roundCoordinate coordinate =
    Round.round 2 coordinate
