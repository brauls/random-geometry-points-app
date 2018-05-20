module Main exposing (..)

import Models exposing (Model, initialModel)
import Msgs exposing (Msg)
import Navigation exposing (Location)
import Routing
import View.View exposing (view)


---- INIT ----


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
    ( initialModel currentRoute, Cmd.none )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnLocationChange location ->
            let
                newRoute =
                    Routing.parseLocation location
            in
            ( { model | route = newRoute }, Cmd.none )

        Msgs.OnToggleFormInputDetails inputId ->
            case model.activeInfoLabelId == inputId of
                True ->
                    ( { model | activeInfoLabelId = "" }, Cmd.none )

                False ->
                    ( { model | activeInfoLabelId = inputId }, Cmd.none )



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
