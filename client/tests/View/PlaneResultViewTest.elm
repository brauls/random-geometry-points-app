module View.PlaneResultViewTest exposing (..)

import Expect
import Html exposing (Html, div)
import Models exposing (..)
import Msgs exposing (Msg)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, tag, text)
import View.PlaneResultView exposing (view)


testPlaneView : Test
testPlaneView =
    describe "Test the PlaneResultView module"
        [ test "view - check presence of view id" <|
            \_ ->
                planeResultHtml
                    |> Query.fromHtml
                    |> Query.findAll [ id "plane-result-view" ]
                    |> Query.count (Expect.equal 1)
        , test "view - check presence of navbar" <|
            \_ ->
                planeResultHtml
                    |> Query.fromHtml
                    |> Query.find [ tag "nav" ]
                    |> Query.has [ id "navbar" ]
        , test "view - check presence of table" <|
            \_ ->
                planeResultHtml
                    |> Query.fromHtml
                    |> Query.find [ tag "table" ]
                    |> Query.children []
                    |> Query.count (Expect.equal 3)
        ]


planeResultHtml : Html Msg
planeResultHtml =
    div []
        [ initialModel HomeRoute
            |> view
        ]
