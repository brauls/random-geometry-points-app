module RoutingTest exposing (..)

import Browser
import Browser.Navigation as Navigation
import Expect
import Models exposing (..)
import Routing exposing (..)
import Test exposing (..)
import Url


testRouting : Test
testRouting =
    describe "Test the Routing module"
        [ test "parseLocation - home" <|
            \_ -> Expect.equal HomeRoute (parseLocation homeLocation)
        , test "parseLocation - plane" <|
            \_ -> Expect.equal PlaneRoute (parseLocation planeLocation)
        , test "parseLocation - plane result" <|
            \_ -> Expect.equal PlaneResultRoute (parseLocation planeResultLocation)
        , test "parseLocation - unknown" <|
            \_ -> Expect.equal NotFoundRoute (parseLocation unknownLocation)
        ]


homeLocation : Url.Url
homeLocation =
    { protocol = Url.Http
    , host = "localhost"
    , port_ = Just 5000
    , path = "/"
    , query = Nothing
    , fragment = Nothing
    }


planeLocation : Url.Url
planeLocation =
    { protocol = Url.Http
    , host = "localhost"
    , port_ = Just 5000
    , path = "/plane"
    , query = Nothing
    , fragment = Nothing
    }


unknownLocation : Url.Url
unknownLocation =
    { protocol = Url.Http
    , host = "localhost"
    , port_ = Just 5000
    , path = "/random"
    , query = Nothing
    , fragment = Nothing
    }


planeResultLocation : Url.Url
planeResultLocation =
    { protocol = Url.Http
    , host = "localhost"
    , port_ = Just 5000
    , path = "/plane-result"
    , query = Nothing
    , fragment = Nothing
    }
