module View.FormElements exposing (GeometryFormParam, geometryForm)

import Html exposing (Html, button, div, form, h5, input, label, p, small, span, text)
import Html.Attributes exposing (attribute, class, for, id, property, tabindex, type_)
import Html.Events exposing (onClick, onInput)
import Json.Encode as Encode
import Models exposing (GeometryParam, GeometryParamType, getFormParamErrorMsg, getParamTypeName)
import Msgs exposing (..)


type alias GeometryFormParam =
    { param : GeometryParam
    , description : String
    }


geometryForm : String -> List GeometryFormParam -> String -> Html Msg
geometryForm geometryName geometryParams activeInfoLabelId =
    let
        formRows =
            List.map (formRow activeInfoLabelId geometryName) geometryParams
    in
    form [] formRows


formRow : String -> String -> GeometryFormParam -> Html Msg
formRow activeInfoLabelId geometryName geometryParam =
    let
        paramTypeName =
            getParamTypeName geometryParam.param.paramType

        postfix =
            geometryName ++ "-" ++ paramTypeName

        labelId =
            "label-" ++ postfix

        formControlId =
            "input-" ++ postfix

        descriptionId =
            "label-description-" ++ postfix

        errorId =
            "label-error-" ++ postfix

        infoButtonId =
            "button-info-" ++ postfix

        describedByIds =
            [ descriptionId, infoButtonId ]

        forceInfoTextVisibility =
            activeInfoLabelId == infoButtonId

        errorMsg =
            getFormParamErrorMsg geometryParam.param.error

        isError =
            case geometryParam.param.error of
                Models.NoError ->
                    False

                _ ->
                    True
    in
    div [ class "form-group row mb-0" ]
        [ formControlLabel labelId formControlId paramTypeName
        , formControl formControlId geometryParam.param.paramType labelId infoButtonId describedByIds forceInfoTextVisibility
        , formControlDescriptionLabel descriptionId geometryParam.description forceInfoTextVisibility
        , formControlErrorLabel errorId errorMsg isError
        ]


formControlLabel : String -> String -> String -> Html msg
formControlLabel labelId formControlId title =
    div [ class "col-form-label col-sm-2 col-4" ]
        [ label [ id labelId, for formControlId ] [ text title ] ]


formControlDescriptionLabel : String -> String -> Bool -> Html msg
formControlDescriptionLabel labelId description forceVisibility =
    let
        classNames =
            case forceVisibility of
                False ->
                    "col-form-label col-sm-6 col-12 d-none d-sm-block"

                True ->
                    "col-form-label col-sm-6 col-12"
    in
    div [ class classNames ]
        [ small [ id labelId, class "text-info" ]
            [ text description ]
        ]


formControl : String -> GeometryParamType -> String -> String -> List String -> Bool -> Html Msg
formControl formControlId paramType labeledBy infoButtonId describedBy isInfoActive =
    div [ class "col-sm-4 col-8" ]
        [ div [ class "row align-items-center" ]
            [ div [ class "col pr-0" ]
                [ input
                    [ id formControlId
                    , class "form-control mx-m-3"
                    , property "aria-labelledby" (Encode.string labeledBy)
                    , property "aria-describedby" (describedBy |> joinStrings |> Encode.string)
                    , property "type" (Encode.string "text")
                    , onInput (Msgs.OnChangePlaneParameter (getParamTypeName paramType))
                    ]
                    []
                ]
            , div [ class "col-xs-auto align-middle" ] [ infoButton infoButtonId isInfoActive ]
            ]
        ]


formControlErrorLabel : String -> String -> Bool -> Html msg
formControlErrorLabel labelId errorMsg isVisible =
    let
        className =
            case isVisible of
                True ->
                    "col-12"

                False ->
                    "d-none col-12"
    in
    div [ class className ]
        [ small [ id labelId, class "bg-warning text-dark" ]
            [ text errorMsg ]
        ]


infoButton : String -> Bool -> Html Msg
infoButton infoButtonId isActive =
    let
        classNames =
            case isActive of
                True ->
                    "btn btn-lg btn-outline-light fas fa-info-circle text-info d-block d-sm-none m-1 active"

                False ->
                    "btn btn-lg btn-outline-light fas fa-info-circle text-info d-block d-sm-none m-1"
    in
    button
        [ id infoButtonId
        , class classNames
        , role "button"
        , property "aria-label" (Encode.string "Press to get detailed description on the input field")
        , onClick (OnToggleFormInputDetails infoButtonId)
        ]
        [ text "" ]


joinStrings : List String -> String
joinStrings labelIds =
    labelIds |> String.join " "


role : String -> Html.Attribute msg
role value =
    attribute "role" value
