module View.ContainerTest exposing (..)

import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (id, attribute, tag)
import Html.Attributes as Attr
import Html
import Expect

import View.Container exposing (embed)

testContainer : Test
testContainer =
  describe "Test the Container module"
      [ test "embed - check if the input content is embedded" <|
          \_ -> Html.div [ Attr.id "embedded-component" ] []
                  |> embed
                  |> Query.fromHtml
                  |> Query.findAll [ id "embedded-component" ]
                  |> Query.count (Expect.equal 1)
      ]
