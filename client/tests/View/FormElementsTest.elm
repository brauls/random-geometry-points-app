module View.FormElementsTest exposing (..)

import Expect
import Fuzz exposing (string)
import Html.Attributes as Attr
import Models exposing (getFormParamErrorMsg)
import Msgs
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, classes, id, tag, text)
import View.FormElements exposing (GeometryFormParam, geometryForm)


testFormElements : Test
testFormElements =
    describe "Test the FormElements module"
        [ test "Test the form row component count (label + input + description-label + error-label)" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.findAll [ tag "div" ]
                    |> Query.first
                    |> Query.children []
                    |> Query.count (Expect.equal 4)
        , test "Test the form row label" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find
                        [ tag "label"
                        , id "label-plane-radius"
                        , attribute <| Attr.for "input-plane-radius"
                        ]
                    |> Query.has [ text "radius" ]
        , test "Test the form row input" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find
                        [ tag "input"
                        , id "input-plane-radius"
                        , "label-plane-radius"
                            |> Attr.attribute "aria-labelledby"
                            |> attribute
                        ]
                    |> Query.has []
        , test "Test the form row description label" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find
                        [ tag "small"
                        , id "label-description-plane-radius"
                        ]
                    |> Query.has [ text "the radius description" ]
        , test "Test the OnChangePlaneParameter msg to be triggered" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find [ tag "input", id "input-plane-radius" ]
                    |> Event.simulate (Event.input "3")
                    |> Event.toResult
                    |> Expect.equal (Ok (Msgs.OnChangePlaneParameter "radius" "3"))
        , test "Test the form row error container classes when no error" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.findAll [ tag "div" ]
                    |> Query.first
                    |> Query.children []
                    |> Query.index 3
                    |> Query.has [ classes [ "d-none" ] ]
        , test "Test the form row error label text when no error" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find [ tag "small", id "label-error-plane-radius" ]
                    |> Query.has [ text "" ]
        , test "Test the form row error container classes when error" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParamWithError ] ""
                    |> Query.fromHtml
                    |> Query.findAll [ tag "div" ]
                    |> Query.first
                    |> Query.children []
                    |> Query.index 3
                    |> Query.hasNot [ classes [ "d-none" ] ]
        , test "Test the form row error label text when error" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParamWithError ] ""
                    |> Query.fromHtml
                    |> Query.find [ tag "small", id "label-error-plane-radius" ]
                    |> Query.has [ Models.NotPositive |> getFormParamErrorMsg |> text ]
        , test "Test the form submit button presence" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find [ tag "button", attribute <| Attr.type_ "submit" ]
                    |> Query.has [ text "create random points" ]
        , test "Test the form submit button OnSubmitPlaneParameters msg to be triggered" <|
            \_ ->
                geometryForm Models.Plane [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find [ tag "button", attribute <| Attr.type_ "submit" ]
                    |> Event.simulate Event.click
                    |> Event.toResult
                    |> Expect.equal (Ok Msgs.OnSubmitPlaneParameters)
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


geometryFormParamWithError : GeometryFormParam
geometryFormParamWithError =
    { param =
        { paramType = Models.Radius
        , value = "-3"
        , error = Models.NotPositive
        }
    , description = "the radius description"
    }
