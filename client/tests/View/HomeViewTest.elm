module View.HomeViewTest exposing (..)

import Expect
import Html exposing (Html, div)
import Models exposing (..)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, tag, text)
import View.HomeView exposing (view, welcomeText)


testHomeView : Test
testHomeView =
    describe "Test the HomeView module"
        [ test "view - check presence of view id" <|
            \_ ->
                homeHtml
                    |> Query.fromHtml
                    |> Query.findAll [ id "home-view" ]
                    |> Query.count (Expect.equal 1)
        , test "view - check presence of navbar" <|
            \_ ->
                homeHtml
                    |> Query.fromHtml
                    |> Query.find [ tag "nav" ]
                    |> Query.has [ id "navbar" ]
        , test "view - check presence of welcome text" <|
            \_ ->
                homeHtml
                    |> Query.fromHtml
                    |> Query.find [ tag "p" ]
                    |> Query.has [ text welcomeText ]
        ]


homeHtml : Html msg
homeHtml =
    div []
        [ initialModel HomeRoute
            |> view
        ]
