module View.PlaneView exposing (view)

import ErrorDecoder exposing (parseHttpError)
import Html exposing (Html, div)
import Html.Attributes exposing (id)
import Models exposing (GeometryParam, GeometryParamType, Model)
import Msgs exposing (Msg)
import RemoteData
import View.ErrorModal as ErrorModal
import View.FormContainer exposing (embed)
import View.FormElements exposing (GeometryFormParam, geometryForm)
import View.Navigator exposing (navbar)


view : Model -> Html Msg
view model =
    let
        requestError =
            case model.randomPlanePoints of
                RemoteData.Failure error ->
                    Just (parseHttpError error)

                _ ->
                    Nothing
    in
    div [ id "plane-view" ]
        [ navbar
        , planeForm model |> embed
        , ErrorModal.modal requestError Msgs.OnClosePlanePointsError
        ]


planeForm : Model -> Html Msg
planeForm model =
    let
        isLoading =
            model.randomPlanePoints == RemoteData.Loading

        formParams =
            planeFormParams model.planeParameters
    in
    geometryForm Models.Plane formParams model.activeInfoLabelId isLoading


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
