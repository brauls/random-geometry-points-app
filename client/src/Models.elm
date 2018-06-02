module Models exposing (..)

import RemoteData exposing (WebData)


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


type GeometryType
    = Plane


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


getGeometryTypeName : GeometryType -> String
getGeometryTypeName geomType =
    case geomType of
        Plane ->
            "plane"


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
      , error = NoInput
      }
    , { paramType = X
      , value = ""
      , error = NoInput
      }
    , { paramType = Y
      , value = ""
      , error = NoInput
      }
    , { paramType = Z
      , value = ""
      , error = NoInput
      }
    , { paramType = I
      , value = ""
      , error = NoInput
      }
    , { paramType = J
      , value = ""
      , error = NoInput
      }
    , { paramType = K
      , value = ""
      , error = NoInput
      }
    , { paramType = Radius
      , value = ""
      , error = NoInput
      }
    ]


type alias GeometryParam =
    { paramType : GeometryParamType
    , value : String
    , error : FormParamError
    }


type alias Point3D =
    { x : Float
    , y : Float
    , z : Float
    }


type alias Model =
    { route : Route
    , isProductionEnv : Bool
    , activeInfoLabelId : String
    , planeParameters : List GeometryParam
    , randomPlanePoints : WebData (List Point3D)
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , isProductionEnv = True
    , activeInfoLabelId = ""
    , planeParameters = initialPlaneParams
    , randomPlanePoints = RemoteData.NotAsked
    }
