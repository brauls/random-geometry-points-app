module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Models exposing (..)
import Msgs exposing (Msg)
import RemoteData
import RequestBuilder exposing (..)
import Routing
import Selectors exposing (hasPlaneFormError)
import Url
import View.FormValidation exposing (validateFormParam)
import View.View exposing (view)


---- INIT ----


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        currentRoute =
            Routing.parseLocation url

        model =
            initialModel key currentRoute
    in
    ( model, Cmd.none )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnLinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.navKey (Url.toString url) )

                Browser.External href ->
                    ( model, Cmd.none )

        Msgs.OnUrlChanged url ->
            let
                newRoute =
                    Routing.parseLocation url
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
                cmd =
                    case response of
                        RemoteData.Success _ ->
                            Navigation.pushUrl model.navKey Routing.planeResultPath

                        _ ->
                            Cmd.none
            in
            ( { model | randomPlanePoints = response }, cmd )

        Msgs.OnClosePlanePointsError ->
            ( { model | randomPlanePoints = RemoteData.NotAsked }, Cmd.none )



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = Msgs.OnUrlChanged
        , onUrlRequest = Msgs.OnLinkClicked
        }
