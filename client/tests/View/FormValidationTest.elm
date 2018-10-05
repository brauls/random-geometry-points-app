module View.FormValidationTest exposing (..)

import Expect
import Fuzz exposing (Fuzzer)
import Models
import Random
import String exposing (fromFloat, fromInt)
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
        , test "validateFormParam - for non-float string radius" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.Radius "abc")
        , test "validateFormParam - for zero values" <|
            \str -> Expect.equal Models.NotPositive (validateFormParam Models.Radius "0.0")
        , test "validateFormParam - for negative radius values" <|
            \str -> Expect.equal Models.NotPositive (validateFormParam Models.Radius "-1.5")
        , test "validateFormParam - for valid radius values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.Radius "3.5")
        , test "validateFormParam - for non-int string point count" <|
            \str -> Expect.equal Models.NotInt (validateFormParam Models.PointCount "3.5")
        , test "validateFormParam - for zero point count values" <|
            \str -> Expect.equal Models.NotPositive (validateFormParam Models.PointCount "0")
        , test "validateFormParam - for negative point count values" <|
            \str -> Expect.equal Models.NotPositive (validateFormParam Models.PointCount "-1")
        , test "validateFormParam - for valid point count values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.PointCount "3")
        , test "validateFormParam - for non-float string x" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.X "abc")
        , test "validateFormParam - for valid x values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.X "-3.4")
        , test "validateFormParam - for non-float string y" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.Y "abc")
        , test "validateFormParam - for valid y values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.Y "0.6")
        , test "validateFormParam - for non-float string z" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.Z "abc")
        , test "validateFormParam - for valid z values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.Z "0.0")
        , test "validateFormParam - for non-float string i" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.I "abc")
        , test "validateFormParam - for valid i values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.I "1.2")
        , test "validateFormParam - for non-float string j" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.J "abc")
        , test "validateFormParam - for valid j values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.J "2")
        , test "validateFormParam - for non-float string k" <|
            \str -> Expect.equal Models.NotFloat (validateFormParam Models.K "abc")
        , test "validateFormParam - for valid k values" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.K "1.3")
        , test "validateFormParam - for unknown parameter type" <|
            \str -> Expect.equal Models.NoError (validateFormParam Models.UnknownParam "abc")
        ]
