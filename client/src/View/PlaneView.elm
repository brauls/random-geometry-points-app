module View.PlaneView exposing (view)

import Html exposing (Html, div, form, input, label, small, text)
import Html.Attributes exposing (class, for, id, property)
import Models exposing (GeometryParam, GeometryParamType, Model)
import Msgs exposing (..)
import View.Container exposing (embed)
import View.FormElements exposing (GeometryFormParam, geometryForm)
import View.Navigator exposing (navbar)


view : Model -> Html Msg
view model =
    div [ id "plane-view" ]
        [ navbar
        , planeForm model |> embed
        ]


planeForm : Model -> Html Msg
planeForm model =
    let
        formParams =
            planeFormParams model.planeParameters
    in
    geometryForm "plane" formParams model.activeInfoLabelId


planeFormParams : List GeometryParam -> List GeometryFormParam
planeFormParams params =
    let
        convertParam =
            \p -> { param = p, description = getParameterDescription p.paramType }

        formParams =
            params
                |> List.map convertParam
    in
    formParams


getParameterDescription : GeometryParamType -> String
getParameterDescription paramType =
    case paramType of
        Models.X ->
            "The x coordinate of the reference point."

        Models.Y ->
            "The y coordinate of the reference point."

        Models.Z ->
            "The z coordinate of the reference point."

        Models.I ->
            "The x component of the normal vector."

        Models.J ->
            "The y component of the normal vector."

        Models.K ->
            "The z component of the normal vector."

        Models.Radius ->
            "The radius around the refernce point in which the plane points are randomly created."

        Models.PointCount ->
            "The number of plane points to be generated"

        _ ->
            ""
