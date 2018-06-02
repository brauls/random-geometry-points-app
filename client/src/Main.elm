module Main exposing (..)

import Debug
import Models exposing (FormParamError, Model, getParamType, initialModel)
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RequestBuilder exposing (..)
import Routing
import Selectors exposing (hasPlaneFormError)
import View.FormValidation exposing (validateFormParam)
import View.View exposing (view)


---- INIT ----


init : Location -> ( Model, Cmd Msg )
init location =
    let
        -- if app runs on port 3000 its the dev server
        isProductionEnv =
            not (location.port_ == "3000")

        currentRoute =
            Routing.parseLocation location

        model =
            initialModel currentRoute
    in
    ( { model | isProductionEnv = isProductionEnv }, Cmd.none )



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

        Msgs.OnChangePlaneParameter paramName value ->
            let
                paramType =
                    getParamType paramName

                error =
                    validateFormParam paramType value

                updateParam =
                    \param ->
                        case param.paramType == paramType of
                            True ->
                                { paramType = paramType, value = value, error = error }

                            False ->
                                param

                planeParams =
                    model.planeParameters
                        |> List.map updateParam
            in
            ( { model | planeParameters = planeParams }, Cmd.none )

        Msgs.OnSubmitPlaneParameters ->
            let
                _ =
                    Debug.log "submit" "now"

                hasFormError =
                    hasPlaneFormError model.planeParameters

                cmd =
                    case hasFormError of
                        True ->
                            Cmd.none

                        False ->
                            randomPlanePointsCmd model.isProductionEnv model.planeParameters
            in
            ( model, cmd )

        Msgs.OnRandomPlanePointsResult response ->
            let
                _ =
                    Debug.log "on result" response
            in
            ( model, Cmd.none )



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
