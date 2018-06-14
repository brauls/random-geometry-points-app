module RequestBuilderTest exposing (..)

import Expect
import Fuzz exposing (float, int, string)
import Json.Decode exposing (Decoder, decodeValue)
import Json.Encode as Json
import Models exposing (Point3D)
import RequestBuilder exposing (..)
import Test exposing (Test, describe, fuzz3, fuzz4, test)


testRequestBuilder : Test
testRequestBuilder =
    describe "Test the RequestBuilder module"
        [ test "randomPlanePointsUri" <|
            \_ ->
                randomPlanePointsUri []
                    |> Expect.equal "/random-plane-points"
        , fuzz3 float float float "point3DDecoder - float input" <|
            \x y z ->
                let
                    json =
                        Json.object
                            [ ( "x", Json.float x )
                            , ( "y", Json.float y )
                            , ( "z", Json.float z )
                            ]
                in
                decodeValue point3DDecoder json
                    |> Expect.equal (Ok (Point3D x y z))
        , fuzz3 int int int "point3DDecoder - int input" <|
            \x y z ->
                let
                    json =
                        Json.object
                            [ ( "x", Json.int x )
                            , ( "y", Json.int y )
                            , ( "z", Json.int z )
                            ]

                    xF =
                        toFloat x

                    yF =
                        toFloat y

                    zF =
                        toFloat z
                in
                decodeValue point3DDecoder json
                    |> Expect.equal (Ok (Point3D xF yF zF))
        , fuzz3 int float int "point3DDecoder - mixed input" <|
            \x y z ->
                let
                    json =
                        Json.object
                            [ ( "x", Json.int x )
                            , ( "y", Json.float y )
                            , ( "z", Json.int z )
                            ]

                    xF =
                        toFloat x

                    zF =
                        toFloat z
                in
                decodeValue point3DDecoder json
                    |> Expect.equal (Ok (Point3D xF y zF))
        , fuzz4 float float float string "point3DDecoder - extended input" <|
            \x y z name ->
                let
                    json =
                        Json.object
                            [ ( "x", Json.float x )
                            , ( "y", Json.float y )
                            , ( "z", Json.float z )
                            , ( "name", Json.string name )
                            ]
                in
                decodeValue point3DDecoder json
                    |> Expect.equal (Ok (Point3D x y z))
        , test "point3DDecoder - empty string" <|
            \_ ->
                decodeValue point3DDecoder (Json.string "")
                    |> Expect.err
        , test "point3DDecoder - json null" <|
            \_ ->
                decodeValue point3DDecoder Json.null
                    |> Expect.err
        , test "point3DDecoder - empty object" <|
            \_ ->
                decodeValue point3DDecoder (Json.object [])
                    |> Expect.err
        ]
