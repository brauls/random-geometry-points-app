module View.RandomPoints3DViewTest exposing (..)

import Expect
import Fuzz exposing (string)
import Http
import Models exposing (Point3D)
import RemoteData exposing (WebData)
import Test exposing (Test, describe, fuzz, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (tag, text)
import View.RandomPoints3DView exposing (view)


testRandomPointsResultView : Test
testRandomPointsResultView =
    describe "Test the RandomPoints3DView module"
        [ fuzz string "view - test the caption text" <|
            \captionText ->
                view captionText randomPointsNotAsked
                    |> Query.fromHtml
                    |> Query.find [ tag "caption" ]
                    |> Query.has [ text captionText ]
        , test "view - test table when not asked" <|
            \_ ->
                view "" randomPointsNotAsked
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children []
                    |> Query.count (Expect.equal 0)
        , test "view - test table when pending" <|
            \_ ->
                view "" randomPointsPending
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children []
                    |> Query.count (Expect.equal 0)
        , test "view - test table when failure" <|
            \_ ->
                view "" randomPointsFailure
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children []
                    |> Query.count (Expect.equal 0)
        , test "view - test table when empty success" <|
            \_ ->
                view "" randomPointsSuccessEmpty
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children []
                    |> Query.count (Expect.equal 0)
        , test "view - test table when success with 3 points" <|
            \_ ->
                view "" (randomPointsSuccess 3)
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children []
                    |> Query.count (Expect.equal 3)
        , test "view - test table when success with 100 points" <|
            \_ ->
                view "" (randomPointsSuccess 100)
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children []
                    |> Query.count (Expect.equal 100)
        ]


randomPointsNotAsked : WebData (List Point3D)
randomPointsNotAsked =
    RemoteData.NotAsked


randomPointsPending : WebData (List Point3D)
randomPointsPending =
    RemoteData.Loading


randomPointsFailure : WebData (List Point3D)
randomPointsFailure =
    RemoteData.Failure Http.NetworkError


randomPointsSuccessEmpty : WebData (List Point3D)
randomPointsSuccessEmpty =
    RemoteData.Success []


randomPointsSuccess : Int -> WebData (List Point3D)
randomPointsSuccess numPoints =
    List.range 1 numPoints
        |> List.map (\_ -> { x = 1, y = 2, z = 3 })
        |> RemoteData.Success
