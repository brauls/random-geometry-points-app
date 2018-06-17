module View.ErrorModalTest exposing (..)

import ErrorDecoder exposing (RequestError)
import Expect
import Html
import Msgs
import Test exposing (..)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (class, tag)
import View.ErrorModal exposing (modal)


testErrorModal : Test
testErrorModal =
    describe "Test the ErrorModal module"
        [ test "modal - when no error" <|
            \_ ->
                [ modal requestErrorNothing Msgs.OnClosePlanePointsError ]
                    |> Html.div []
                    |> Query.fromHtml
                    |> Query.find [ tag "div" ]
                    |> Query.has [ class "d-none" ]
        , test "modal - when error" <|
            \_ ->
                [ modal requestErrorJust Msgs.OnClosePlanePointsError ]
                    |> Html.div []
                    |> Query.fromHtml
                    |> Query.findAll [ tag "button" ]
                    |> Query.count (Expect.equal 1)
        , test "modal - check msg on click" <|
            \_ ->
                [ modal requestErrorJust Msgs.OnClosePlanePointsError ]
                    |> Html.div []
                    |> Query.fromHtml
                    |> Query.find [ tag "button" ]
                    |> Event.simulate Event.click
                    |> Event.expect Msgs.OnClosePlanePointsError
        ]


requestErrorNothing : Maybe RequestError
requestErrorNothing =
    Nothing


requestErrorJust : Maybe RequestError
requestErrorJust =
    Just
        { message = "custom message"
        , hint = "custom hint"
        }
