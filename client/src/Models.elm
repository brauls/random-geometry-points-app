module Models exposing (..)


type Route
    = HomeRoute
    | PlaneRoute
    | NotFoundRoute


type alias Model =
    { route : Route
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    }
