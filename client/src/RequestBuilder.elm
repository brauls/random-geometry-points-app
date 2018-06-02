module RequestBuilder exposing (randomPlanePointsCmd)

import Http
import Json.Decode as Decode
import Models exposing (GeometryParam, Point3D)
import Msgs exposing (Msg)
import RemoteData


randomPlanePointsCmd : Bool -> List GeometryParam -> Cmd Msg
randomPlanePointsCmd isProductionEnv planeParams =
    let
        uri =
            randomPlanePointsUri planeParams

        request =
            case isProductionEnv of
                True ->
                    requestRandomPointsProd uri point3DArrayDecoder

                False ->
                    requestRandomPointsDev uri point3DArrayDecoder
    in
    request
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


requestRandomPointsProd : String -> Decode.Decoder a -> Http.Request a
requestRandomPointsProd uri decoder =
    Http.get uri decoder


requestRandomPointsDev : String -> Decode.Decoder a -> Http.Request a
requestRandomPointsDev uri decoder =
    let
        url =
            "http://localhost:5000" ++ uri
    in
    Http.get url decoder
