module View.RandomPoints3DView exposing (view)

import Html exposing (Html, caption, div, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, id, property, scope)
import Models exposing (Point3D)
import RemoteData exposing (WebData)
import Round


view : String -> WebData (List Point3D) -> Html msg
view captionText randomPointsResult =
    let
        randomPoints =
            case randomPointsResult of
                RemoteData.Success points ->
                    points

                _ ->
                    []
    in
    div [ class "container-fluid" ]
        [ div [ class "row mt-2" ]
            [ div [ class "col-lg-2" ] []
            , div [ class "col-lg-8" ]
                [ resultTable captionText randomPoints
                ]
            , div [ class "col-lg-2" ] []
            ]
        ]


resultTable : String -> List Point3D -> Html msg
resultTable captionText randomPoints =
    div [ class "table-responsive" ]
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
        [ th [] [ text (toString (index + 1)) ]
        , td [] [ text (Round.round 2 randomPoint.x) ]
        , td [] [ text (Round.round 2 randomPoint.y) ]
        , td [] [ text (Round.round 2 randomPoint.z) ]
        ]
