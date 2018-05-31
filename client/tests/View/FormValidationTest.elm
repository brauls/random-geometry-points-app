module View.FormValidationTest exposing (..)

import Expect
import Fuzz exposing (Fuzzer)
import Models
import Random
import Test exposing (Test, describe, fuzz, test)
import View.FormValidation exposing (validateFormParam)


testFormValidation : Test
testFormValidation =
    describe "Test the FormValidation module"
        [ test "validateFormParam - for empty string radius" <|
            \_ -> Expect.equal Models.NoInput (validateFormParam Models.Radius "")
        , test "validateFormParam - for empty string x" <|
            \_ -> Expect.equal Models.NoInput (validateFormParam Models.X "")
        , test "validateFormParam - for empty string for unknown parameter type" <|
            \_ -> Expect.equal Models.NoInput (validateFormParam Models.UnknownParam "")
        , fuzz nonFloatStringFuzzer "validateFormParam - for non-float string radius" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.Radius str)
        , fuzz zeroOrLessFloatStringFuzzer "validateFormParam - for zero or negative radius values" <|
            \str -> Expect.equal Models.NotPositive (validateFormParam Models.Radius str)
        , fuzz positiveFloatStringFuzzer "validateFormParam - for valid radius values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.Radius str)
        , fuzz nonIntStringFuzzer "validateFormParam - for non-int string point count" <|
            \str -> Expect.equal Models.NotInt (validateFormParam Models.PointCount str)
        , fuzz zeroOrLessIntStringFuzzer "validateFormParam - for zero or negative point count values" <|
            \str -> Expect.equal Models.NotPositive (validateFormParam Models.PointCount str)
        , fuzz positiveIntStringFuzzer "validateFormParam - for valid point count values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.PointCount str)
        , fuzz nonFloatStringFuzzer "validateFormParam - for non-float string x" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.X str)
        , fuzz floatStringFuzzer "validateFormParam - for valid x values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.X str)
        , fuzz nonFloatStringFuzzer "validateFormParam - for non-float string y" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.Y str)
        , fuzz floatStringFuzzer "validateFormParam - for valid y values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.Y str)
        , fuzz nonFloatStringFuzzer "validateFormParam - for non-float string z" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.Z str)
        , fuzz floatStringFuzzer "validateFormParam - for valid z values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.Z str)
        , fuzz nonFloatStringFuzzer "validateFormParam - for non-float string i" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.I str)
        , fuzz floatStringFuzzer "validateFormParam - for valid i values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.I str)
        , fuzz nonFloatStringFuzzer "validateFormParam - for non-float string j" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.J str)
        , fuzz floatStringFuzzer "validateFormParam - for valid j values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.J str)
        , fuzz nonFloatStringFuzzer "validateFormParam - for non-float string k" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.K str)
        , fuzz floatStringFuzzer "validateFormParam - for valid k values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.K str)
        , fuzz nonFloatStringFuzzer "validateFormParam - for unknown parameter type" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.UnknownParam str)
        ]


nonFloatStringFuzzer : Fuzzer String
nonFloatStringFuzzer =
    let
        mapFuzzNoEmpty =
            \str ->
                case str == "" of
                    True ->
                        nonFloatStringFuzzer

                    False ->
                        Fuzz.constant str

        mapFuzzNoFloat =
            \str ->
                case str |> String.toFloat of
                    Ok _ ->
                        nonFloatStringFuzzer

                    Err _ ->
                        Fuzz.constant str
    in
    Fuzz.string
        |> Fuzz.andThen mapFuzzNoEmpty
        |> Fuzz.andThen mapFuzzNoFloat


floatStringFuzzer : Fuzzer String
floatStringFuzzer =
    Fuzz.map toString Fuzz.float


positiveFloatStringFuzzer : Fuzzer String
positiveFloatStringFuzzer =
    let
        floatFuzzer =
            Fuzz.floatRange 0.001 (Random.maxInt |> toFloat)
    in
    Fuzz.map toString floatFuzzer


zeroOrLessFloatStringFuzzer : Fuzzer String
zeroOrLessFloatStringFuzzer =
    let
        floatFuzzer =
            Fuzz.floatRange -(Random.maxInt |> toFloat) 0.0
    in
    Fuzz.map toString floatFuzzer


nonIntStringFuzzer : Fuzzer String
nonIntStringFuzzer =
    let
        mapFuzzNoEmpty =
            \str ->
                case str == "" of
                    True ->
                        nonIntStringFuzzer

                    False ->
                        Fuzz.constant str

        mapFuzzNoInt =
            \str ->
                case str |> String.toInt of
                    Ok _ ->
                        nonIntStringFuzzer

                    Err _ ->
                        Fuzz.constant str
    in
    Fuzz.string
        |> Fuzz.andThen mapFuzzNoEmpty
        |> Fuzz.andThen mapFuzzNoInt


intStringFuzzer : Fuzzer String
intStringFuzzer =
    Fuzz.map toString Fuzz.int


positiveIntStringFuzzer : Fuzzer String
positiveIntStringFuzzer =
    let
        intFuzzer =
            Fuzz.intRange 1 Random.maxInt
    in
    Fuzz.map toString intFuzzer


zeroOrLessIntStringFuzzer : Fuzzer String
zeroOrLessIntStringFuzzer =
    let
        intFuzzer =
            Fuzz.intRange -Random.maxInt 0
    in
    Fuzz.map toString intFuzzer
