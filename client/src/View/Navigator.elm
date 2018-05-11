module View.Navigator exposing (navbar)

import Html exposing (Html, div, text, nav, i, ul, li, a)
import Html.Attributes exposing (class, href, id)

import Routing

navbar : Html msg
navbar =
  nav [ id "navbar", class "navbar navbar-expand-lg navbar-light bg-light" ]
    [ brand
    , div [ class "container-fluid" ]
        [ ul [ class "navbar-nav" ]
            [ navitem Routing.planePath "Plane"
            ]
        ]
    ]

brand : Html msg
brand =
  a [ navitemId "brand", href Routing.homePath ]
    [ i [ class "navbar-brand fas fa-random" ] []
    ]

navitem : String -> String -> Html msg
navitem path title =
  li [ navitemId title, class "nav-item" ]
    [ a [ class "nav-link", href path ] [ text title ]
    ]

navitemId : String -> Html.Attribute msg
navitemId title =
  title
    |> String.toLower
    |> String.append "nav-item-"
    |> id
