module View.ErrorModal exposing (modal)

import ErrorDecoder exposing (RequestError)
import Html exposing (Html, button, div, h5, i, p, text)
import Html.Attributes exposing (class, property, style)
import Html.Events exposing (onClick)
import Json.Encode as Encode
import Msgs exposing (Msg)


modal : Maybe RequestError -> Msg -> Html Msg
modal requestErrorMaybe closeMsg =
    let
        markup =
            case requestErrorMaybe of
                Just requestError ->
                    modalDialog requestError closeMsg

                Nothing ->
                    div [ class "d-none" ] []
    in
    markup


modalDialog : RequestError -> Msg -> Html Msg
modalDialog requestError closeMsg =
    div []
        [ div [ class "modal in", style "display" "block", property "role" (Encode.string "dialog") ]
            [ div [ class "modal-dialog modal-lg", property "role" (Encode.string "document") ]
                [ div [ class "modal-content" ]
                    [ modalHeader "Random points error" closeMsg
                    , modalBody requestError.message requestError.hint
                    ]
                ]
            ]
        , div [ class "modal-backdrop", style "opacity" "0.5" ] []
        ]


modalHeader : String -> Msg -> Html Msg
modalHeader headerText closeMsg =
    div [ class "modal-header bg-warning text-uppercase" ]
        [ h5
            [ class "modal-title"
            , property "aria-label" (Encode.string "Close")
            ]
            [ text headerText ]
        , button
            [ class "close btn-outline-none"
            , property "aria-label" (Encode.string "Close")
            , onClick closeMsg
            ]
            [ i [ class "fas fa-times small", property "aria-hidden" (Encode.bool True) ] []
            ]
        ]


modalBody : String -> String -> Html msg
modalBody message hint =
    div [ class "modal-body" ]
        [ p [] [ text message ]
        , p [ class "small" ] [ text hint ]
        ]
