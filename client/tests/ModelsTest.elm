module ModelsTest exposing (..)

import Expect
import Models exposing (..)
import Test exposing (..)


testModels : Test
testModels =
    describe "Test the Models module"
        [ test "initialModel" <|
            \_ -> Expect.equal { route = HomeRoute } (initialModel HomeRoute)
        ]
