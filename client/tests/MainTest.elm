module MainTest exposing (..)

import Expect
import Http
import Main exposing (..)
import Models exposing (..)
import Msgs exposing (..)
import Navigation exposing (Location)
import RemoteData exposing (WebData)
import Routing
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
            \_ -> Expect.equal expectedLocationChangeModel (getUpdateLocationModel planeLocation)
        , test "update - check location change cmd" <|
            \_ -> Expect.equal Cmd.none (getUpdateLocationCmd planeLocation)
        , test "update - check set active info label model when previously unavailable" <|
            \_ -> Expect.equal expectedAvailableInfoLabelModel (getUpdateActiveInfoLabelModel expectedUnavailableInfoLabelModel "info-label-id")
        , test "update - check set active info label model when previously available" <|
            \_ -> Expect.equal expectedUnavailableInfoLabelModel (getUpdateActiveInfoLabelModel expectedAvailableInfoLabelModel "")
        , test "update - check set active info label cmd when previously unavailable" <|
            \_ -> Expect.equal Cmd.none (getUpdateActiveInfoLabelCmd expectedUnavailableInfoLabelModel "info-label-id")
        , test "update - check set active info label cmd when previously available" <|
            \_ -> Expect.equal Cmd.none (getUpdateActiveInfoLabelCmd expectedAvailableInfoLabelModel "")
        , test "update - check update plane radius" <|
            \_ ->
                getUpdatePlaneParamModel (getInitModel homeLocation) "radius" "3.5"
                    |> Expect.equal (expectedUpdatePlaneParamModel Models.Radius "3.5")
        , test "update - check update plane radius with invalid value" <|
            \_ ->
                getUpdatePlaneParamModel (getInitModel homeLocation) "radius" "-4"
                    |> Expect.equal (expectedUpdatePlaneParamErrorModel Models.Radius "-4" Models.NotPositive)
        , test "update - check update plane parameter cmd" <|
            \_ ->
                getUpdatePlaneParamCmd (getInitModel homeLocation) "radius" "3"
                    |> Expect.equal Cmd.none
        , test "update - check plane points result model when not asked" <|
            \_ ->
                getUpdateRandomPlanePointsResultModel (getInitModel planeLocation) RemoteData.NotAsked
                    |> Expect.equal (expectedUpdateRandomPlanePointsResultModel RemoteData.NotAsked)
        , test "update - check plane points result model when pending" <|
            \_ ->
                getUpdateRandomPlanePointsResultModel (getInitModel planeLocation) RemoteData.Loading
                    |> Expect.equal (expectedUpdateRandomPlanePointsResultModel RemoteData.Loading)
        , test "update - check plane points result model when failure" <|
            \_ ->
                getUpdateRandomPlanePointsResultModel (getInitModel planeLocation) (RemoteData.Failure Http.NetworkError)
                    |> Expect.equal (expectedUpdateRandomPlanePointsResultModel (RemoteData.Failure Http.NetworkError))
        , test "update - check plane points result model when success" <|
            \_ ->
                getUpdateRandomPlanePointsResultModel (getInitModel planeLocation) (RemoteData.Success [])
                    |> Expect.equal (expectedUpdateRandomPlanePointsResultModel (RemoteData.Success []))
        , test "update - check plane points result cmd when not asked" <|
            \_ ->
                getUpdateRandomPlanePointsResultCmd (getInitModel planeLocation) RemoteData.NotAsked
                    |> Expect.equal Cmd.none
        , test "update - check plane points result cmd when pending" <|
            \_ ->
                getUpdateRandomPlanePointsResultCmd (getInitModel planeLocation) RemoteData.Loading
                    |> Expect.equal Cmd.none
        , test "update - check plane points result cmd when failure" <|
            \_ ->
                getUpdateRandomPlanePointsResultCmd (getInitModel planeLocation) (RemoteData.Failure Http.NetworkError)
                    |> Expect.equal Cmd.none
        , test "update - check plane points result cmd when success" <|
            \_ ->
                getUpdateRandomPlanePointsResultCmd (getInitModel planeLocation) (RemoteData.Success [])
                    |> Expect.equal (Navigation.newUrl Routing.planeResultPath)
        , test "update - check close plane points error model when has error" <|
            \_ ->
                getUpdateClosePlanePointsErrorModel (planePointsErrorModel True)
                    |> Expect.equal (planePointsErrorModel False)
        , test "update - check close plane points error model when has no error" <|
            \_ ->
                getUpdateClosePlanePointsErrorModel (planePointsErrorModel False)
                    |> Expect.equal (planePointsErrorModel False)
        ]


expectedLocationChangeModel : Model
expectedLocationChangeModel =
    { route = PlaneRoute
    , activeInfoLabelId = ""
    , planeParameters = initialPlaneParams
    , randomPlanePoints = RemoteData.NotAsked
    }


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


expectedAvailableInfoLabelModel : Model
expectedAvailableInfoLabelModel =
    { route = HomeRoute
    , activeInfoLabelId = "info-label-id"
    , planeParameters = initialPlaneParams
    , randomPlanePoints = RemoteData.NotAsked
    }


expectedUnavailableInfoLabelModel : Model
expectedUnavailableInfoLabelModel =
    { route = HomeRoute
    , activeInfoLabelId = ""
    , planeParameters = initialPlaneParams
    , randomPlanePoints = RemoteData.NotAsked
    }


getUpdateActiveInfoLabelModel : Model -> String -> Model
getUpdateActiveInfoLabelModel currentModel labelId =
    currentModel
        |> Main.update (Msgs.OnToggleFormInputDetails labelId)
        |> Tuple.first


getUpdateActiveInfoLabelCmd : Model -> String -> Cmd Msg
getUpdateActiveInfoLabelCmd currentModel labelId =
    currentModel
        |> Main.update (Msgs.OnToggleFormInputDetails labelId)
        |> Tuple.second


expectedUpdatePlaneParamModel : GeometryParamType -> String -> Model
expectedUpdatePlaneParamModel paramType value =
    let
        mapFormParam =
            \param ->
                if param.paramType == paramType then
                    { paramType = paramType
                    , value = value
                    , error = Models.NoError
                    }
                else
                    param
    in
    { route = HomeRoute
    , activeInfoLabelId = ""
    , planeParameters =
        initialPlaneParams
            |> List.map mapFormParam
    , randomPlanePoints = RemoteData.NotAsked
    }


expectedUpdatePlaneParamErrorModel : GeometryParamType -> String -> FormParamError -> Model
expectedUpdatePlaneParamErrorModel paramType value error =
    let
        mapFormParam =
            \param ->
                if param.paramType == paramType then
                    { paramType = paramType
                    , value = value
                    , error = error
                    }
                else
                    param
    in
    { route = HomeRoute
    , activeInfoLabelId = ""
    , planeParameters =
        initialPlaneParams
            |> List.map mapFormParam
    , randomPlanePoints = RemoteData.NotAsked
    }


getUpdatePlaneParamModel : Model -> String -> String -> Model
getUpdatePlaneParamModel currentModel paramName value =
    currentModel
        |> Main.update (Msgs.OnChangePlaneParameter paramName value)
        |> Tuple.first


getUpdatePlaneParamCmd : Model -> String -> String -> Cmd Msg
getUpdatePlaneParamCmd currentModel paramName value =
    currentModel
        |> Main.update (Msgs.OnChangePlaneParameter paramName value)
        |> Tuple.second


getUpdateRandomPlanePointsResultModel : Model -> WebData (List Point3D) -> Model
getUpdateRandomPlanePointsResultModel currentModel remoteData =
    currentModel
        |> Main.update (Msgs.OnRandomPlanePointsResult remoteData)
        |> Tuple.first


getUpdateRandomPlanePointsResultCmd : Model -> WebData (List Point3D) -> Cmd Msg
getUpdateRandomPlanePointsResultCmd currentModel remoteData =
    currentModel
        |> Main.update (Msgs.OnRandomPlanePointsResult remoteData)
        |> Tuple.second


expectedUpdateRandomPlanePointsResultModel : WebData (List Point3D) -> Model
expectedUpdateRandomPlanePointsResultModel randomPointsResult =
    let
        model =
            initialModel PlaneRoute
    in
    { model | randomPlanePoints = randomPointsResult }


getUpdateClosePlanePointsErrorModel : Model -> Model
getUpdateClosePlanePointsErrorModel currentModel =
    currentModel
        |> Main.update Msgs.OnClosePlanePointsError
        |> Tuple.first


getUpdateClosePlanePointsErrorCmd : Model -> Cmd Msg
getUpdateClosePlanePointsErrorCmd currentModel =
    currentModel
        |> Main.update Msgs.OnClosePlanePointsError
        |> Tuple.second


planePointsErrorModel : Bool -> Model
planePointsErrorModel hasError =
    let
        webData =
            case hasError of
                True ->
                    RemoteData.Failure Http.NetworkError

                False ->
                    RemoteData.NotAsked

        model =
            initialModel PlaneRoute
    in
    { model | randomPlanePoints = webData }
