module View.ViewTest exposing (..)

import Expect
import Html exposing (Html, div)
import Models exposing (..)
import Msgs exposing (Msg)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, tag, text)
import View.View exposing (view)


testView : Test
testView =
    describe "Test the View module"
        [ test "view - check home route" <|
            \_ ->
                getHtml HomeRoute
                    |> Query.fromHtml
                    |> Query.findAll [ id "home-view" ]
                    |> Query.count (Expect.equal 1)
        , test "view - check not found route" <|
            \_ ->
                getHtml NotFoundRoute
                    |> Query.fromHtml
                    |> Query.findAll [ id "home-view" ]
                    |> Query.count (Expect.equal 1)
        , test "view - check plane route" <|
            \_ ->
                getHtml PlaneRoute
                    |> Query.fromHtml
                    |> Query.findAll [ id "plane-view" ]
                    |> Query.count (Expect.equal 1)
        , test "view - check plane result route" <|
            \_ ->
                getHtml PlaneResultRoute
                    |> Query.fromHtml
                    |> Query.findAll [ id "plane-result-view" ]
                    |> Query.count (Expect.equal 1)
        ]


getHtml : Route -> Html Msg
getHtml route =
    div []
        [ initialModel route
            |> view
        ]
