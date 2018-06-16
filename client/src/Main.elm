module Main exposing (..)

import Debug
import Models exposing (..)
import Msgs exposing (Msg)
import Navigation exposing (Location)
import RemoteData
import RequestBuilder exposing (..)
import Routing
import Selectors exposing (hasPlaneFormError)
import View.FormValidation exposing (validateFormParam)
import View.View exposing (view)


---- INIT ----


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location

        model =
            initialModel currentRoute
    in
    ( model, Cmd.none )



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
                hasFormError =
                    hasPlaneFormError model.planeParameters

                cmd =
                    case hasFormError of
                        True ->
                            Cmd.none

                        False ->
                            randomPlanePointsCmd model.planeParameters

                queryStatus =
                    case hasFormError of
                        True ->
                            model.randomPlanePoints

                        False ->
                            RemoteData.Loading
            in
            ( { model | randomPlanePoints = queryStatus }, cmd )

        Msgs.OnRandomPlanePointsResult response ->
            let
                _ =
                    Debug.log "response received" response

                cmd =
                    case response of
                        RemoteData.Success _ ->
                            Navigation.newUrl Routing.planeResultPath

                        _ ->
                            Cmd.none
            in
            ( { model | randomPlanePoints = response }, cmd )



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
