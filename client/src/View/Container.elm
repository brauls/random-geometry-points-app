module View.Container exposing (embed)

import Html exposing (Html, div)
import Html.Attributes exposing (class)


embed : Html msg -> Html msg
embed content =
    div [ class "container-fluid" ]
        [ div [ class "row mt-2" ]
            [ div [ class "col-lg-1" ] []
            , div [ class "col-lg-10" ] [ content ]
            , div [ class "col-lg-1" ] []
            ]
        ]
