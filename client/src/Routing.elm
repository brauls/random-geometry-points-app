module Routing exposing (..)

import Models exposing (Route)
import Navigation exposing (Location)
import UrlParser exposing (Parser, map, oneOf, parseHash, s, top)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map Models.HomeRoute top
        , map Models.PlaneResultRoute (s "plane-result")
        , map Models.PlaneRoute (s "plane")
        ]


parseLocation : Location -> Route
parseLocation location =
    case parseHash matchers location of
        Just route ->
            route

        Nothing ->
            Models.NotFoundRoute


homePath : String
homePath =
    "#"


planePath : String
planePath =
    "#plane"


planeResultPath : String
planeResultPath =
    "#plane-result"
