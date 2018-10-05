module View.View exposing (view)

import Browser
import Html exposing (Html)
import Models exposing (..)
import Msgs exposing (Msg)
import View.HomeView as HomeView
import View.PlaneResultView as PlaneResultView
import View.PlaneView as PlaneView


view : Model -> Browser.Document Msg
view model =
    let
        html =
            case model.route of
                Models.HomeRoute ->
                    HomeView.view model

                Models.PlaneRoute ->
                    PlaneView.view model

                Models.PlaneResultRoute ->
                    PlaneResultView.view model

                Models.NotFoundRoute ->
                    HomeView.view model
    in
    { title = "Elm App"
    , body = [ html ]
    }
