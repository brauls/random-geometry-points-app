module MainTest exposing (..)

import Expect
import Main exposing (..)
import Models exposing (..)
import Msgs exposing (..)
import Navigation exposing (Location)
import RoutingTest exposing (homeLocation, planeLocation, unknownLocation)
import Test exposing (..)


testMainInit : Test
testMainInit =
    describe "Test the Main module's init function"
        [ test "init - check home route" <|
            \_ -> Expect.equal HomeRoute (getInitRoute homeLocation)
        , test "init - check plane route" <|
            \_ -> Expect.equal PlaneRoute (getInitRoute planeLocation)
        , test "init - check initial model" <|
            \_ -> Expect.equal (initialModel PlaneRoute) (getInitModel planeLocation)
        , test "init - check command" <|
            \_ -> Expect.equal Cmd.none (getInitCmd planeLocation)
        ]


getInitRoute : Location -> Route
getInitRoute location =
    init location
        |> Tuple.first
        |> .route


getInitModel : Location -> Model
getInitModel location =
    init location
        |> Tuple.first


getInitCmd : Location -> Cmd Msg
getInitCmd location =
    init location
        |> Tuple.second


testMainUpdate : Test
testMainUpdate =
    describe "Test the Main module's update function"
        [ test "update - check location change model" <|
            \_ -> Expect.equal (getInitModel planeLocation) (getUpdateLocationModel planeLocation)
        , test "update - check location change cmd" <|
            \_ -> Expect.equal Cmd.none (getUpdateLocationCmd planeLocation)
        ]


getUpdateLocationModel : Location -> Model
getUpdateLocationModel location =
    getInitModel unknownLocation
        |> Main.update (Msgs.OnLocationChange location)
        |> Tuple.first


getUpdateLocationCmd : Location -> Cmd Msg
getUpdateLocationCmd location =
    getInitModel unknownLocation
        |> Main.update (Msgs.OnLocationChange location)
        |> Tuple.second
