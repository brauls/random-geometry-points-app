module View.HomeView exposing (view, welcomeText)

import Html exposing (Html, div , p, h1, text)
import Html.Attributes exposing (class, id)

import Models exposing (Model)
import View.Navigator exposing (navbar)

view : Model -> Html msg
view model =
  div [ id "home-view" ]
    [ navbar
    , welcomeScreen
    ]

welcomeScreen : Html msg
welcomeScreen =
  div [ class "jumbotron home-container" ]
    [ h1 [ class "display-4" ] [ text "create random points" ]
    , p [ class "lead" ] [ text welcomeText ]
    ]

welcomeText : String
welcomeText =
  """Using this app you can create an arbitrary number of random 2D or 3D points
  on geometry surfaces. Click on one of the supported geometry types above to get started.
  """
