module SelectorsTest exposing (..)

import Expect
import Models exposing (GeometryParam)
import Selectors exposing (..)
import Test exposing (Test, describe, test)


testSelectors : Test
testSelectors =
    describe "Test the selectors module"
        [ test "hasPlaneFormError - no error" <|
            \_ ->
                hasPlaneFormError planeParamsNoError
                    |> Expect.false "Expect no plane form params error"
        , test "hasPlaneFormError - error" <|
            \_ ->
                hasPlaneFormError planeParamsError
                    |> Expect.true "Expect plane form params error"
        , test "hasPlaneFormError - no input" <|
            \_ ->
                hasPlaneFormError planeParamsNoInput
                    |> Expect.true "Expect plane form params error (missing input)"
        ]


planeParamsNoError : List GeometryParam
planeParamsNoError =
    [ { paramType = Models.Radius
      , value = "3.5"
      , error = Models.NoError
      }
    , { paramType = Models.X
      , value = "2"
      , error = Models.NoError
      }
    ]


planeParamsError : List GeometryParam
planeParamsError =
    [ { paramType = Models.Radius
      , value = "-3.5"
      , error = Models.NotPositive
      }
    , { paramType = Models.X
      , value = "2"
      , error = Models.NoError
      }
    ]


planeParamsNoInput : List GeometryParam
planeParamsNoInput =
    [ { paramType = Models.Radius
      , value = "3"
      , error = Models.NoError
      }
    , { paramType = Models.X
      , value = ""
      , error = Models.NoInput
      }
    ]
