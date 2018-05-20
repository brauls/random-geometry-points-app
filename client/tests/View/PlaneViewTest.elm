module View.PlaneViewTest exposing (..)

import Expect
import Html exposing (Html, div)
import Models exposing (..)
import Msgs exposing (Msg)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, tag, text)
import View.PlaneView exposing (view)


testPlaneView : Test
testPlaneView =
    describe "Test the PlaneView module"
        [ test "view - check presence of view id" <|
            \_ ->
                planeHtml
                    |> Query.fromHtml
                    |> Query.findAll [ id "plane-view" ]
                    |> Query.count (Expect.equal 1)
        ]


planeHtml : Html Msg
planeHtml =
    div []
        [ initialModel HomeRoute
            |> view
        ]
