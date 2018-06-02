module ModelsTest exposing (..)

import Expect
import Models exposing (..)
import RemoteData
import Test exposing (..)


testModels : Test
testModels =
    describe "Test the Models module"
        [ test "initialModel" <|
            \_ -> Expect.equal expectedModel (initialModel HomeRoute)
        , test "initialPlaneParams - no error as default" <|
            \_ ->
                initialPlaneParams
                    |> List.map (\param -> param.error == NoInput)
                    |> List.foldr (&&) True
                    |> Expect.true "Expected the initial paramter to contain no error"
        , test "initialPlaneParams - empty string as default value" <|
            \_ ->
                initialPlaneParams
                    |> List.map (\param -> param.value == "")
                    |> List.foldr (&&) True
                    |> Expect.true "Expected the initial paramter to have an empty string as value"
        ]


expectedModel : Model
expectedModel =
    { route = HomeRoute
    , activeInfoLabelId = ""
    , planeParameters = initialPlaneParams
    , randomPlanePoints = RemoteData.NotAsked
    , isProductionEnv = True
    }
