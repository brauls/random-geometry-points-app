module View.PlaneViewTest exposing (..)

import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, attribute, tag, text)
import Html exposing (Html, div)
import Expect

import Models exposing (..)
import View.PlaneView exposing (view)

testPlaneView : Test
testPlaneView =
  describe "Test the PlaneView module"
      [ test "view - check presence of view id" <|
          \_ -> planeHtml
                  |> Query.fromHtml
                  |> Query.findAll [ id "plane-view" ]
                  |> Query.count (Expect.equal 1)
      ]

planeHtml : Html msg
planeHtml =
  div []
    [ initialModel HomeRoute
        |> view
    ]
