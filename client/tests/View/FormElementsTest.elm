module View.FormElementsTest exposing (..)

import Expect
import Fuzz exposing (string)
import Html.Attributes as Attr
import Models
import Msgs
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, tag, text)
import View.FormElements exposing (GeometryFormParam, geometryForm)


testFormElements : Test
testFormElements =
    describe "Test the FormElements module"
        [ fuzz string "Test the form row label" <|
            \geometryName ->
                geometryForm geometryName [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find
                        [ tag "label"
                        , id ("label-" ++ geometryName ++ "-radius")
                        , attribute <| Attr.for ("input-" ++ geometryName ++ "-radius")
                        ]
                    |> Query.has [ text "radius" ]
        , fuzz string "Test the form row input" <|
            \geometryName ->
                geometryForm geometryName [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find
                        [ tag "input"
                        , id ("input-" ++ geometryName ++ "-radius")
                        , "label-"
                            ++ geometryName
                            ++ "-radius"
                            |> Attr.attribute "aria-labelledby"
                            |> attribute
                        ]
                    |> Query.has []
        , fuzz string "Test the form row description label" <|
            \geometryName ->
                geometryForm geometryName [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find
                        [ tag "small"
                        , id ("label-description-" ++ geometryName ++ "-radius")
                        ]
                    |> Query.has [ text "the radius description" ]
        , test "Test the OnChangePlaneParameter msg to be triggered" <|
            \_ ->
                geometryForm "plane" [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find [ tag "input", id "input-plane-radius" ]
                    |> Event.simulate (Event.input "3")
                    |> Event.toResult
                    |> Expect.equal (Ok (Msgs.OnChangePlaneParameter "radius" "3"))
        ]


geometryFormParam : GeometryFormParam
geometryFormParam =
    { param =
        { paramType = Models.Radius
        , value = ""
        , error = Models.NoError
        }
    , description = "the radius description"
    }
