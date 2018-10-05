module View.FormValidation exposing (validateFormParam)

import Models exposing (FormParamError, GeometryParamType)


validateFormParam : GeometryParamType -> String -> FormParamError
validateFormParam paramType value =
    case value == "" of
        True ->
            Models.NoInput

        False ->
            validate paramType value


validate : GeometryParamType -> String -> FormParamError
validate paramType value =
    case paramType of
        Models.Radius ->
            validateRadius value

        Models.PointCount ->
            validatePointCount value

        Models.UnknownParam ->
            Models.NoError

        _ ->
            validateGeneralGeometryParam value


validateRadius : String -> FormParamError
validateRadius radius =
    case radius |> String.toFloat of
        Just radiusF ->
            case radiusF > 0.0 of
                True ->
                    Models.NoError

                False ->
                    Models.NotPositive

        Nothing ->
            Models.NotFloat


validatePointCount : String -> FormParamError
validatePointCount pointCount =
    case pointCount |> String.toInt of
        Just pointCountI ->
            case pointCountI > 0 of
                True ->
                    Models.NoError

                False ->
                    Models.NotPositive

        Nothing ->
            Models.NotInt


validateGeneralGeometryParam : String -> FormParamError
validateGeneralGeometryParam value =
    case value |> String.toFloat of
        Just _ ->
            Models.NoError

        Nothing ->
            Models.NotFloat
