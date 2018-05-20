module View.FormElements exposing (GeometryFormParam, geometryForm)

import Html exposing (Html, button, div, form, h5, input, label, p, small, span, text)
import Html.Attributes exposing (attribute, class, for, id, property, tabindex, type_)
import Html.Events exposing (onClick)
import Json.Encode as Encode
import Msgs exposing (..)


type alias GeometryFormParam =
    { name : String
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
        postfix =
            geometryName ++ "-" ++ geometryParam.name

        labelId =
            "label-" ++ postfix

        formControlId =
            "input-" ++ postfix

        descriptionId =
            "label-description-" ++ postfix

        infoButtonId =
            "button-info-" ++ postfix

        describedByIds =
            [ descriptionId, infoButtonId ]

        forceVisibility =
            activeInfoLabelId == infoButtonId
    in
    div [ class "form-group row mb-0" ]
        [ formControlLabel labelId formControlId geometryParam.name
        , formControl formControlId labelId infoButtonId describedByIds forceVisibility
        , formControlDescriptionLabel descriptionId geometryParam.description forceVisibility
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


formControl : String -> String -> String -> List String -> Bool -> Html Msg
formControl formControlId labeledBy infoButtonId describedBy isInfoActive =
    div [ class "col-sm-4 col-8" ]
        [ div [ class "row align-items-center" ]
            [ div [ class "col pr-0" ]
                [ input
                    [ id formControlId
                    , class "form-control mx-m-3"
                    , property "aria-labelledby" (Encode.string labeledBy)
                    , property "aria-describedby" (describedBy |> joinStrings |> Encode.string)
                    , property "type" (Encode.string "text")
                    ]
                    []
                ]
            , div [ class "col-xs-auto align-middle" ] [ infoButton infoButtonId isInfoActive ]
            ]
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
