module ErrorDecoder exposing (..)

import Http


type alias RequestError =
    { message : String
    , hint : String
    }


parseHttpError : Http.Error -> RequestError
parseHttpError httpError =
    let
        errorMsg =
            case httpError of
                Http.Timeout ->
                    timeoutError

                Http.NetworkError ->
                    networkError

                Http.BadUrl _ ->
                    badUrlError

                Http.BadPayload _ _ ->
                    badPayloadError

                Http.BadStatus response ->
                    badStatusError response
    in
    errorMsg


timeoutError : RequestError
timeoutError =
    { message = "Your request ran into the timeout"
    , hint = "Please try again later or contact the administrator"
    }


networkError : RequestError
networkError =
    { message = "A network error occured"
    , hint = "Please check your internet connection or try again later"
    }


badUrlError : RequestError
badUrlError =
    { message = "An error occured during request building"
    , hint = "Please contact the administrator"
    }


badPayloadError : RequestError
badPayloadError =
    { message = "An error occured during parsing the random points result"
    , hint = "Please contact the administrator"
    }


badStatusError : Http.Response String -> RequestError
badStatusError response =
    { message = response.body
    , hint = "The status code was HTTP " ++ toString response.status.code
    }
