module Routing exposing (parseLocation)

import Navigation exposing (Location)
import UrlParser exposing (Parser, parseHash, map, oneOf, top, s)

import Models exposing (Route)

matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map Models.HomeRoute top
    , map Models.PlaneRoute (s ("plane"))
    ]

parseLocation : Location -> Route
parseLocation location =
  case (parseHash matchers location) of
    Just route -> route
    Nothing -> Models.NotFoundRoute