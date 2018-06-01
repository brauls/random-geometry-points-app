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
                geometryForm "plane" [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.findAll [ tag "div" ]
                    |> Query.first
                    |> Query.children []
                    |> Query.count (Expect.equal 4)
        , fuzz string "Test the form row label" <|
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
        , test "Test the form row error container classes when no error" <|
            \_ ->
                geometryForm "plane" [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.findAll [ tag "div" ]
                    |> Query.first
                    |> Query.children []
                    |> Query.index 3
                    |> Query.has [ classes [ "d-none" ] ]
        , test "Test the form row error label text when no error" <|
            \_ ->
                geometryForm "plane" [ geometryFormParam ] ""
                    |> Query.fromHtml
                    |> Query.find [ tag "small", id "label-error-plane-radius" ]
                    |> Query.has [ text "" ]
        , test "Test the form row error container classes when error" <|
            \_ ->
                geometryForm "plane" [ geometryFormParamWithError ] ""
                    |> Query.fromHtml
                    |> Query.findAll [ tag "div" ]
                    |> Query.first
                    |> Query.children []
                    |> Query.index 3
                    |> Query.hasNot [ classes [ "d-none" ] ]
        , test "Test the form row error label text when error" <|
            \_ ->
                geometryForm "plane" [ geometryFormParamWithError ] ""
                    |> Query.fromHtml
                    |> Query.find [ tag "small", id "label-error-plane-radius" ]
                    |> Query.has [ Models.NotPositive |> getFormParamErrorMsg |> text ]
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
