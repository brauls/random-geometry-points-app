module View.PlaneView exposing (view)

import Html exposing (Html, div, text)

import Models exposing (Model)

view : Model -> Html msg
view model =
  div [] [ text "Plane" ]