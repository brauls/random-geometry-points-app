module Msgs exposing (..)

import Browser
import Models exposing (Point3D)
import RemoteData exposing (WebData)
import Url


type Msg
    = OnLinkClicked Browser.UrlRequest
    | OnUrlChanged Url.Url
    | OnToggleFormInputDetails String
    | OnChangePlaneParameter String String
    | OnSubmitPlaneParameters
    | OnRandomPlanePointsResult (WebData (List Point3D))
    | OnClosePlanePointsError
