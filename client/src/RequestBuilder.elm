module RequestBuilder exposing (..)

import Http
import Json.Decode as Decode
import Models exposing (GeometryParam, Point3D, getParamTypeName)
import Msgs exposing (Msg)
import RemoteData


randomPlanePointsCmd : List GeometryParam -> Cmd Msg
randomPlanePointsCmd planeParams =
    let
        uri =
            randomPlanePointsUri planeParams

        request =
            requestRandomPoints uri point3DArrayDecoder
    in
    request
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnRandomPlanePointsResult


randomPlanePointsUri : List GeometryParam -> String
randomPlanePointsUri planeParams =
    let
        parseQueryParam =
            \param ->
                "&" ++ getParamTypeName param.paramType ++ "=" ++ param.value

        queryParams =
            planeParams
                |> List.map parseQueryParam
                |> List.foldl (++) ""
                |> String.dropLeft 1
    in
    "/random-plane-points?" ++ queryParams


point3DArrayDecoder : Decode.Decoder (List Point3D)
point3DArrayDecoder =
    Decode.list point3DDecoder


point3DDecoder : Decode.Decoder Point3D
point3DDecoder =
    Decode.map3 Point3D
        (Decode.field "x" Decode.float)
        (Decode.field "y" Decode.float)
        (Decode.field "z" Decode.float)


requestRandomPoints : String -> Decode.Decoder a -> Http.Request a
requestRandomPoints uri decoder =
    Http.get uri decoder
