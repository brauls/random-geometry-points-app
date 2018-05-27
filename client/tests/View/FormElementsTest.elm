module View.FormElementsTest exposing (..)

import Fuzz exposing (string)
import Html.Attributes as Attr
import Models
import Test exposing (Test, describe, fuzz)
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
