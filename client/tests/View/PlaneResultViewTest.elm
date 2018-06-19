module View.PlaneResultViewTest exposing (..)

import Expect
import Html exposing (Html, div)
import Models exposing (..)
import Msgs exposing (Msg)
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, id, tag, text)
import View.PlaneResultView exposing (view)


testPlaneView : Test
testPlaneView =
    describe "Test the PlaneResultView module"
        [ test "view - check presence of view id" <|
            \_ ->
                planeResultHtml
                    |> Query.fromHtml
                    |> Query.findAll [ id "plane-result-view" ]
                    |> Query.count (Expect.equal 1)
        , test "view - check presence of navbar" <|
            \_ ->
                planeResultHtml
                    |> Query.fromHtml
                    |> Query.find [ tag "nav" ]
                    |> Query.has [ id "navbar" ]
        , test "view - check presence of table" <|
            \_ ->
                planeResultHtml
                    |> Query.fromHtml
                    |> Query.find [ tag "table" ]
                    |> Query.children []
                    |> Query.count (Expect.equal 3)
        , test "view - check caption for plane without input" <|
            \_ ->
                planeResultHtml
                    |> Query.fromHtml
                    |> Query.find [ tag "caption" ]
                    |> Query.hasNot [ text "The randomly created plane points." ]
        , test "view - check caption for plane without invalid input" <|
            \_ ->
                planeResultHtmlWithInvalidPlaneParams
                    |> Query.fromHtml
                    |> Query.find [ tag "caption" ]
                    |> Query.hasNot [ text "The randomly created plane points." ]
        , test "view - check caption for plane with valid input" <|
            \_ ->
                planeResultHtmlWithValidPlaneParams
                    |> Query.fromHtml
                    |> Query.find [ tag "caption" ]
                    |> Query.has
                        [ """The randomly created plane points. The plane definition was: x=1, y=2, z=3, i=1, j=0, k=0, radius=4.5""" |> text
                        ]
        ]


planeResultHtml : Html Msg
planeResultHtml =
    div []
        [ initialModel PlaneResultRoute
            |> view
        ]


planeResultHtmlWithInvalidPlaneParams : Html Msg
planeResultHtmlWithInvalidPlaneParams =
    let
        initModel =
            initialModel PlaneResultRoute

        invalidPlaneParams =
            [ { paramType = PointCount
              , value = ""
              , error = NoError
              }
            , { paramType = X
              , value = ""
              , error = NotInt
              }
            , { paramType = Y
              , value = ""
              , error = NotFloat
              }
            , { paramType = Z
              , value = ""
              , error = NotPositive
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

        invalidPlaneModel =
            { initModel | planeParameters = invalidPlaneParams }
    in
    div []
        [ invalidPlaneModel
            |> view
        ]


planeResultHtmlWithValidPlaneParams : Html Msg
planeResultHtmlWithValidPlaneParams =
    let
        initModel =
            initialModel PlaneResultRoute

        validPlaneParams =
            [ { paramType = PointCount
              , value = "10"
              , error = NoError
              }
            , { paramType = X
              , value = "1"
              , error = NoError
              }
            , { paramType = Y
              , value = "2"
              , error = NoError
              }
            , { paramType = Z
              , value = "3"
              , error = NoError
              }
            , { paramType = I
              , value = "1"
              , error = NoError
              }
            , { paramType = J
              , value = "0"
              , error = NoError
              }
            , { paramType = K
              , value = "0"
              , error = NoError
              }
            , { paramType = Radius
              , value = "4.5"
              , error = NoError
              }
            ]

        validPlaneModel =
            { initModel | planeParameters = validPlaneParams }
    in
    div []
        [ validPlaneModel
            |> view
        ]
