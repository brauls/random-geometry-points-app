module RoutingTest exposing (..)

import Test exposing (..)
import Expect
import Navigation exposing (Location)

import Routing exposing (..)
import Models exposing (..)

testRouting : Test
testRouting =
  describe "Test the Routing module"
      [ test "parseLocation home"
          <| \_ -> Expect.equal HomeRoute (parseLocation homeLocation)
      , test "parseLocation plane"
          <| \_ -> Expect.equal PlaneRoute (parseLocation planeLocation)
      , test "parseLocation unknown"
          <| \_ -> Expect.equal NotFoundRoute (parseLocation unknownLocation)
      ]

homeLocation : Location
homeLocation = getLocation homePath

planeLocation : Location
planeLocation = getLocation planePath

unknownLocation : Location
unknownLocation = getLocation "#random"

getLocation : String -> Location
getLocation hash =
  { hash = hash
  , host = ""
  , hostname = ""
  , href = ""
  , origin = ""
  , password = ""
  , pathname = ""
  , port_ = ""
  , protocol = ""
  , search = ""
  , username = ""
  }
