module ErrorDecoderTest exposing (..)

import Dict
import ErrorDecoder exposing (..)
import Expect
import Http
import Json.Encode as Encode
import Test exposing (..)


testErrorDecoder : Test
testErrorDecoder =
    describe "Test the error decoder module"
        [ test "parseHttpError - timeout" <|
            \_ ->
                parseHttpError Http.Timeout
                    |> Expect.equal timeoutError
        , test "parseHttpError - network error" <|
            \_ ->
                parseHttpError Http.NetworkError
                    |> Expect.equal networkError
        , test "parseHttpError - bad url" <|
            \_ ->
                parseHttpError (Http.BadUrl "")
                    |> Expect.equal badUrlError
        , test "parseHttpError - bad payload" <|
            \_ ->
                httpResponse 500
                    |> Http.BadPayload ""
                    |> parseHttpError
                    |> Expect.equal badPayloadError
        , test "parseHttpError - bad status 404" <|
            \_ ->
                httpResponse 404
                    |> Http.BadStatus
                    |> parseHttpError
                    |> Expect.equal badStatusError404
        , test "parseHttpError - bad status 500" <|
            \_ ->
                httpResponse 500
                    |> Http.BadStatus
                    |> parseHttpError
                    |> Expect.equal badStatusError500
        ]


httpResponse : Int -> Http.Response String
httpResponse httpErrorCode =
    let
        url =
            ""

        status =
            { code = httpErrorCode, message = "" }

        headers =
            Dict.empty

        body =
            Http.emptyBody
    in
    Http.Response url status headers "Custom message"


badStatusError404 : RequestError
badStatusError404 =
    { message = "Custom message"
    , hint = "The status code was HTTP 404"
    }


badStatusError500 : RequestError
badStatusError500 =
    { message = "Custom message"
    , hint = "The status code was HTTP 500"
    }
