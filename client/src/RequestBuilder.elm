module RequestBuilder exposing (randomPlanePointsCmd)

import Http
import Json.Decode as Decode
import Models exposing (GeometryParam, Point3D)
import Msgs exposing (Msg)
import RemoteData


randomPlanePointsCmd : List GeometryParam -> Cmd Msg
randomPlanePointsCmd planeParams =
    Http.get (randomPlanePointsUri planeParams) point3DArrayDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnRandomPlanePointsResult


randomPlanePointsUri : List GeometryParam -> String
randomPlanePointsUri planeParams =
    "/random-plane-points"


point3DArrayDecoder : Decode.Decoder (List Point3D)
point3DArrayDecoder =
    Decode.list point3DDecoder


point3DDecoder : Decode.Decoder Point3D
point3DDecoder =
    Decode.map3 Point3D
        (Decode.field "x" Decode.float)
        (Decode.field "y" Decode.float)
        (Decode.field "z" Decode.float)
