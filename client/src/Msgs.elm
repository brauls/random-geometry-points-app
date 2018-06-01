module Msgs exposing (..)

import Navigation exposing (Location)


type Msg
    = OnLocationChange Location
    | OnToggleFormInputDetails String
    | OnChangePlaneParameter String String
    | OnSubmitPlaneParameters
