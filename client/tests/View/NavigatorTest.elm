module View.NavigatorTest exposing (..)


todo =
    "see https://github.com/eeue56/elm-html-test/issues/69"



-- import Expect
-- import Html
-- import Html.Attributes as Attr
-- import Test exposing (..)
-- import Test.Html.Query as Query
-- import Test.Html.Selector exposing (attribute, id, tag)
-- import View.Navigator exposing (navbar)
-- testNavigator : Test
-- testNavigator =
--     describe "Test the Navigator module"
--         [ test "navbar - check the presence of the id" <|
--             \_ ->
--                 Html.div [] [ navbar ]
--                     |> Query.fromHtml
--                     |> Query.find [ tag "nav" ]
--                     |> Query.has [ id "navbar" ]
--         , test "navbar - check home link" <|
--             \_ ->
--                 navbar
--                     |> Query.fromHtml
--                     |> Query.findAll [ id "nav-item-brand", attribute <| Attr.href "#" ]
--                     |> Query.count (Expect.equal 1)
--         , test "navbar - check plane link" <|
--             \_ ->
--                 navbar
--                     |> Query.fromHtml
--                     |> Query.findAll [ id "nav-item-plane", attribute <| Attr.href "#plane" ]
--                     |> Query.count (Expect.equal 1)
--         ]
