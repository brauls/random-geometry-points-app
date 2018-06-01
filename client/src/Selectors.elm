module Selectors exposing (..)

import Models exposing (GeometryParam)


hasPlaneFormError : List GeometryParam -> Bool
hasPlaneFormError planeParams =
    let
        mapFormError =
            \param -> not (param.error == Models.NoError)
    in
    planeParams
        |> List.map mapFormError
        |> List.foldr (||) False
