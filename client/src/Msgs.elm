module Msgs exposing (..)

import Models exposing (Point3D)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnLocationChange Location
    | OnToggleFormInputDetails String
    | OnChangePlaneParameter String String
    | OnSubmitPlaneParameters
    | OnRandomPlanePointsResult (WebData (List Point3D))
