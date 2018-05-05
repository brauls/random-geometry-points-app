module View.HomeView exposing (view)

import Html exposing (Html, div)

import Models exposing (Model)
import View.Navigator exposing (navbar)

view : Model -> Html msg
view model =
  div [] [ navbar ]