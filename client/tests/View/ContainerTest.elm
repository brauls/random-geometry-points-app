module View.ContainerTest exposing (..)

import Expect
import Html
import Html.Attributes as Attr
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, tag)
import View.Container exposing (embed)


testContainer : Test
testContainer =
    describe "Test the Container module"
        [ test "embed - check if the input content is embedded" <|
            \_ ->
                Html.div [ Attr.id "embedded-component" ] []
                    |> embed
                    |> Query.fromHtml
                    |> Query.findAll [ id "embedded-component" ]
                    |> Query.count (Expect.equal 1)
        ]
