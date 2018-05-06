module ModelsTest exposing (..)

import Test exposing (..)
import Expect

import Models exposing (..)

testModels : Test
testModels =
  describe "Test the Models module"
      [ test "initialModel"
          <| \_ -> Expect.equal { route = HomeRoute } (initialModel HomeRoute)
      ]