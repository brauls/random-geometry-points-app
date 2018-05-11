module View.ViewTest exposing (..)

import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, attribute, tag, text)
import Html exposing (Html, div)
import Expect

import Models exposing (..)
import View.View exposing (view)

testView : Test
testView =
  describe "Test the View module"
      [ test "view - check home route" <|
          \_ -> getHtml HomeRoute
                  |> Query.fromHtml
                  |> Query.findAll [ id "home-view" ]
                  |> Query.count (Expect.equal 1)
      , test "view - check not found route" <|
          \_ -> getHtml NotFoundRoute
                  |> Query.fromHtml
                  |> Query.findAll [ id "home-view" ]
                  |> Query.count (Expect.equal 1)
      , test "view - check plane route" <|
          \_ -> getHtml PlaneRoute
                  |> Query.fromHtml
                  |> Query.findAll [ id "plane-view" ]
                  |> Query.count (Expect.equal 1)
      ]

getHtml : Route -> Html msg
getHtml route =
  div []
    [ initialModel route
        |> view
    ]
