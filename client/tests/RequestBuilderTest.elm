module RequestBuilderTest exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, float, int, string, tuple)
import Json.Decode exposing (Decoder, decodeValue)
import Json.Encode as Json
import Models exposing (GeometryParam, Point3D)
import RequestBuilder exposing (..)
import Test exposing (Test, describe, fuzz, fuzz3, test)
import Tuple


testRequestBuilder : Test
testRequestBuilder =
    describe "Test the RequestBuilder module"
        [ test "randomPlanePointsUri - without plane params" <|
            \_ ->
                randomPlanePointsUri []
                    |> Expect.equal "/random-plane-points?"
        , test "randomPlanePointsUri - with plane params" <|
            \_ ->
                randomPlanePointsUri getTestPlaneParams
                    |> Expect.equal expectedPlanePointsUri
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
            \x_y_z_name ->
                let
                    x_y =
                        Tuple.first x_y_z_name

                    z_name =
                        Tuple.second x_y_z_name

                    x =
                        Tuple.first x_y

                    y =
                        Tuple.second x_y

                    z =
                        Tuple.first z_name

                    name =
                        Tuple.second z_name

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


getTestPlaneParams : List GeometryParam
getTestPlaneParams =
    [ { paramType = Models.Radius
      , value = "4"
      , error = Models.NoError
      }
    , { paramType = Models.X
      , value = "-2"
      , error = Models.NoError
      }
    , { paramType = Models.Y
      , value = "1.5"
      , error = Models.NoError
      }
    , { paramType = Models.Z
      , value = "-0.66"
      , error = Models.NoError
      }
    , { paramType = Models.I
      , value = "1"
      , error = Models.NoError
      }
    , { paramType = Models.J
      , value = "0"
      , error = Models.NoError
      }
    , { paramType = Models.K
      , value = "0"
      , error = Models.NoError
      }
    , { paramType = Models.PointCount
      , value = "965"
      , error = Models.NoError
      }
    ]


expectedPlanePointsUri : String
expectedPlanePointsUri =
    "/random-plane-points?number=965&k=0&j=0&i=1&z=-0.66&y=1.5&x=-2&radius=4"


fuzz4 : Fuzzer a -> Fuzzer b -> Fuzzer c -> Fuzzer d -> String -> (( ( a, b ), ( c, d ) ) -> Expectation) -> Test
fuzz4 fuzzA fuzzB fuzzC fuzzD desc exp =
    let
        fuzzAB =
            tuple ( fuzzA, fuzzB )

        fuzzCD =
            tuple ( fuzzC, fuzzD )

        fuzzer =
            tuple ( fuzzAB, fuzzCD )
    in
    fuzz fuzzer desc exp
