module View.Navigator exposing (navbar)

import Html exposing (Html, div, text, nav, i, ul, li, a)
import Html.Attributes exposing (class, href)

import Routing

navbar : Html msg
navbar =
  nav [ class "navbar navbar-expand-lg navbar-light bg-light" ]
    [ brand
    , div [ class "container-fluid" ]
        [ ul [ class "navbar-nav" ]
            [ navitem Routing.planePath "Plane"
            ]
        ]
    ]

brand : Html msg
brand =
  a [ href Routing.homePath ]
    [ i [ class "navbar-brand fas fa-random" ] []
    ]

navitem : String -> String -> Html msg
navitem path title =
  li [ class "nav-item" ]
    [ a [ class "nav-link", href path ] [ text title ]
    ]