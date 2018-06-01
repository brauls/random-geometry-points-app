module View.FormElements exposing (GeometryFormParam, geometryForm)

import Html exposing (Html, button, div, form, h5, input, label, p, small, span, text)
import Html.Attributes exposing (attribute, class, disabled, for, id, property, required, tabindex, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Json.Encode as Encode
import Models exposing (GeometryParam, GeometryParamType, getFormParamErrorMsg, getParamTypeName)
import Msgs exposing (..)


type alias GeometryFormParam =
    { param : GeometryParam
    , description : String
    }


type alias GeometryFormMetaData =
    { formControlId : String
    , labelId : String
    , descriptionLabelId : String
    , errorLabelId : String
    , infoButtonId : String
    , alwaysShowInfoText : Bool
    }


geometryForm : String -> List GeometryFormParam -> String -> Html Msg
geometryForm geometryName geometryParams activeInfoLabelId =
    let
        formRows =
            List.map (formRow activeInfoLabelId geometryName) geometryParams

        submitButton =
            formControlSubmitButton geometryParams
    in
    form [] (formRows ++ [ submitButton ])


formRow : String -> String -> GeometryFormParam -> Html Msg
formRow activeInfoLabelId geometryName geometryParam =
    let
        paramTypeName =
            getParamTypeName geometryParam.param.paramType

        postfix =
            geometryName ++ "-" ++ paramTypeName

        infoButtonId =
            "button-info-" ++ postfix

        formMetaData =
            { formControlId = "input-" ++ postfix
            , labelId = "label-" ++ postfix
            , descriptionLabelId = "label-description-" ++ postfix
            , errorLabelId = "label-error-" ++ postfix
            , infoButtonId = infoButtonId
            , alwaysShowInfoText = activeInfoLabelId == infoButtonId
            }
    in
    div [ class "form-group row mb-0" ]
        [ formControlLabel formMetaData geometryParam
        , formControl formMetaData geometryParam
        , formControlDescriptionLabel formMetaData geometryParam
        , formControlErrorLabel formMetaData geometryParam
        ]


formControlLabel : GeometryFormMetaData -> GeometryFormParam -> Html msg
formControlLabel formMetaData formParam =
    let
        formControlId =
            formMetaData.formControlId

        labelId =
            formMetaData.labelId

        title =
            getParamTypeName formParam.param.paramType
    in
    div [ class "col-form-label col-sm-2 col-4" ]
        [ label [ id labelId, for formControlId ] [ text title ] ]


formControlDescriptionLabel : GeometryFormMetaData -> GeometryFormParam -> Html msg
formControlDescriptionLabel formMetaData formParam =
    let
        labelId =
            formMetaData.descriptionLabelId

        forceVisibility =
            formMetaData.alwaysShowInfoText

        classNames =
            case forceVisibility of
                False ->
                    "col-form-label col-sm-6 col-12 d-none d-sm-block"

                True ->
                    "col-form-label col-sm-6 col-12"

        description =
            formParam.description
    in
    div [ class classNames ]
        [ small [ id labelId, class "text-info" ]
            [ text description ]
        ]


formControl : GeometryFormMetaData -> GeometryFormParam -> Html Msg
formControl formMetaData formParam =
    let
        formControlId =
            formMetaData.formControlId

        labeledBy =
            formMetaData.labelId

        infoButtonId =
            formMetaData.infoButtonId

        isInfoActive =
            formMetaData.alwaysShowInfoText

        descriptionId =
            formMetaData.descriptionLabelId

        describedBy =
            [ descriptionId, infoButtonId ]

        paramTypeName =
            getParamTypeName formParam.param.paramType

        currentValue =
            formParam.param.value
    in
    div [ class "col-sm-4 col-8" ]
        [ div [ class "row align-items-center" ]
            [ div [ class "col pr-0" ]
                [ input
                    [ id formControlId
                    , value currentValue
                    , class "form-control mx-m-3"
                    , property "aria-labelledby" (Encode.string labeledBy)
                    , property "aria-describedby" (describedBy |> joinStrings |> Encode.string)
                    , property "type" (Encode.string "text")
                    , onInput (Msgs.OnChangePlaneParameter paramTypeName)
                    , required True
                    ]
                    []
                ]
            , div [ class "col-xs-auto align-middle" ] [ infoButton infoButtonId isInfoActive ]
            ]
        ]


formControlErrorLabel : GeometryFormMetaData -> GeometryFormParam -> Html msg
formControlErrorLabel formMetaData formParam =
    let
        labelId =
            formMetaData.errorLabelId

        errorMsg =
            getFormParamErrorMsg formParam.param.error

        className =
            case formParam.param.error of
                Models.NoError ->
                    "d-none col-12"

                _ ->
                    "col-12"
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


formControlSubmitButton : List GeometryFormParam -> Html Msg
formControlSubmitButton geometryParams =
    let
        mapFormError =
            \param -> not (param.param.error == Models.NoError)

        hasFormError =
            geometryParams
                |> List.map mapFormError
                |> List.foldr (||) False
    in
    div [ class "col-12" ]
        [ button
            [ class "btn btn-primary btn-block"
            , type_ "submit"
            , disabled hasFormError
            , onSubmit Msgs.OnSubmitPlaneParameters
            ]
            [ text "create random points"
            ]
        ]


joinStrings : List String -> String
joinStrings labelIds =
    labelIds |> String.join " "


role : String -> Html.Attribute msg
role value =
    attribute "role" value
