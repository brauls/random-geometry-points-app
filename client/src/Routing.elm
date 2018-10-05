module Routing exposing (..)

import Models exposing (Route)
import Url
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Models.HomeRoute top
        , map Models.PlaneResultRoute (s "plane-result")
        , map Models.PlaneRoute (s "plane")
        ]


parseLocation : Url.Url -> Route
parseLocation url =
    case parse matchers url of
        Just route ->
            route

        Nothing ->
            Models.NotFoundRoute


homePath : String
homePath =
    "/"


planePath : String
planePath =
    "plane"


planeResultPath : String
planeResultPath =
    "plane-result"
