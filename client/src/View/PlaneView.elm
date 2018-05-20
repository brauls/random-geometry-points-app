module View.PlaneView exposing (view)

import Html exposing (Html, div, form, input, label, small, text)
import Html.Attributes exposing (class, for, id, property)
import Models exposing (Model)
import Msgs exposing (..)
import View.Container exposing (embed)
import View.FormElements exposing (GeometryFormParam, geometryForm)
import View.Navigator exposing (navbar)


view : Model -> Html Msg
view model =
    div [ id "plane-view" ]
        [ navbar
        , planeForm model |> embed
        ]


planeForm : Model -> Html Msg
planeForm model =
    geometryForm "plane" planeFormParams model.activeInfoLabelId


planeFormParams : List GeometryFormParam
planeFormParams =
    let
        params =
            [ { name = "number"
              , description = "The number of plane points to be generated"
              }
            , { name = "x"
              , description = "The x coordinate of the reference point."
              }
            , { name = "y"
              , description = "The y coordinate of the reference point."
              }
            , { name = "z"
              , description = "The z coordinate of the reference point."
              }
            , { name = "i"
              , description = "The x component of the normal vector."
              }
            , { name = "j"
              , description = "The y component of the normal vector."
              }
            , { name = "k"
              , description = "The z component of the normal vector."
              }
            , { name = "radius"
              , description = "The radius around the refernce point in which the plane points are randomly created."
              }
            ]
    in
    params
