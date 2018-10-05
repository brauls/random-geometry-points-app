module View.PlaneViewTest exposing (..)


todo =
    "see https://github.com/eeue56/elm-html-test/issues/69"



-- import Expect
-- import Html exposing (Html, div)
-- import Http
-- import Models exposing (..)
-- import Msgs exposing (Msg)
-- import RemoteData
-- import Test exposing (..)
-- import Test.Html.Query as Query
-- import Test.Html.Selector exposing (attribute, id, tag, text)
-- import View.PlaneView exposing (view)
-- testPlaneView : Test
-- testPlaneView =
--     describe "Test the PlaneView module"
--         [ test "view - check presence of view id" <|
--             \_ ->
--                 planeHtml
--                     |> Query.fromHtml
--                     |> Query.findAll [ id "plane-view" ]
--                     |> Query.count (Expect.equal 1)
--         , test "view - check presence of navbar" <|
--             \_ ->
--                 planeHtml
--                     |> Query.fromHtml
--                     |> Query.find [ tag "nav" ]
--                     |> Query.has [ id "navbar" ]
--         , test "view - check presence of form" <|
--             \_ ->
--                 planeHtml
--                     |> Query.fromHtml
--                     |> Query.find [ tag "form" ]
--                     |> Query.children []
--                     |> Query.count (Expect.equal 9)
--         , test "view - check that no modal is displayed when no error" <|
--             \_ ->
--                 planeHtml
--                     |> Query.fromHtml
--                     |> Query.findAll [ tag "button" ]
--                     |> Query.count (Expect.equal 9)
--         , test "view - check that no modal is displayed when error" <|
--             \_ ->
--                 planeHtmlWithError
--                     |> Query.fromHtml
--                     |> Query.findAll [ tag "button" ]
--                     |> Query.count (Expect.equal 10)
--         ]
-- planeHtml : Html Msg
-- planeHtml =
--     div []
--         [ initialModel HomeRoute
--             |> view
--         ]
-- planeHtmlWithError : Html Msg
-- planeHtmlWithError =
--     let
--         model =
--             initialModel HomeRoute
--     in
--     div []
--         [ { model | randomPlanePoints = RemoteData.Failure Http.NetworkError }
--             |> view
--         ]
