module Models exposing (..)


type Route
    = HomeRoute
    | PlaneRoute
    | NotFoundRoute


type alias Model =
    { route : Route
    , activeInfoLabelId : String
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , activeInfoLabelId = ""
    }
