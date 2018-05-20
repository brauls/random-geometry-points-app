module View.View exposing (view)

import Html exposing (Html)
import Models exposing (..)
import Msgs exposing (Msg)
import View.HomeView as HomeView
import View.PlaneView as PlaneView


view : Model -> Html Msg
view model =
    case model.route of
        Models.HomeRoute ->
            HomeView.view model

        Models.PlaneRoute ->
            PlaneView.view model

        Models.NotFoundRoute ->
            HomeView.view model
