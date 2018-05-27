module Models exposing (..)


type Route
    = HomeRoute
    | PlaneRoute
    | NotFoundRoute


type FormParamError
    = NoError
    | NoInput
    | NotInt
    | NotFloat
    | NotPositive


getFormParamErrorMsg : FormParamError -> String
getFormParamErrorMsg error =
    case error of
        NoError ->
            ""

        NoInput ->
            ""

        NotInt ->
            "The input value has to be an integer"

        NotFloat ->
            "The input value has to be a decimal number"

        NotPositive ->
            "The input value has to be positive"


type GeometryParamType
    = Radius
    | X
    | Y
    | Z
    | I
    | J
    | K
    | PointCount
    | UnknownParam


getParamTypeName : GeometryParamType -> String
getParamTypeName paramType =
    case paramType of
        Radius ->
            "radius"

        X ->
            "x"

        Y ->
            "y"

        Z ->
            "z"

        I ->
            "i"

        J ->
            "j"

        K ->
            "k"

        PointCount ->
            "number"

        UnknownParam ->
            "unknown"


getParamType : String -> GeometryParamType
getParamType paramName =
    case paramName of
        "x" ->
            X

        "y" ->
            Y

        "z" ->
            Z

        "i" ->
            I

        "j" ->
            J

        "k" ->
            K

        "number" ->
            PointCount

        "radius" ->
            Radius

        _ ->
            UnknownParam


initialPlaneParams : List GeometryParam
initialPlaneParams =
    [ { paramType = PointCount
      , value = ""
      , error = NoError
      }
    , { paramType = X
      , value = ""
      , error = NoError
      }
    , { paramType = Y
      , value = ""
      , error = NoError
      }
    , { paramType = Z
      , value = ""
      , error = NoError
      }
    , { paramType = I
      , value = ""
      , error = NoError
      }
    , { paramType = J
      , value = ""
      , error = NoError
      }
    , { paramType = K
      , value = ""
      , error = NoError
      }
    , { paramType = Radius
      , value = ""
      , error = NoError
      }
    ]


type alias GeometryParam =
    { paramType : GeometryParamType
    , value : String
    , error : FormParamError
    }


type alias Model =
    { route : Route
    , activeInfoLabelId : String
    , planeParameters : List GeometryParam
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , activeInfoLabelId = ""
    , planeParameters = initialPlaneParams
    }
