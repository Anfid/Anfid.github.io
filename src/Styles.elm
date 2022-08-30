module Styles exposing (Style(..), bar, bgColor, button, heading, link, paragraph, sansSerif, smallButton)

import Element exposing (Color, fill, rgb255)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
import Html.Attributes


type Style
    = Dark
    | Light



-- STYLES


bar : Style -> List (Element.Attribute msg) -> List (Element.Attribute msg)
bar style attributes =
    [ Element.width fill, Background.color <| barColor style ]
        ++ attributes


sansSerif : Style -> Int -> List (Element.Attribute msg) -> List (Element.Attribute msg)
sansSerif style size attributes =
    [ Font.color <| fgColor style
    , Font.size size
    , Font.family [ Font.typeface "Arial", Font.sansSerif ]
    ]
        ++ attributes


heading : Style -> Int -> List (Element.Attribute msg) -> List (Element.Attribute msg)
heading style level attributes =
    let
        ( color, size, padding ) =
            case level of
                1 ->
                    ( fgColor style, 32, 15 )

                2 ->
                    ( fgColor style, 28, 20 )

                3 ->
                    ( fgFadedColor style, 22, 20 )

                4 ->
                    ( fgFadedColor style, 20, 20 )

                _ ->
                    ( fgFadedColor style, 18, 20 )
    in
    [ Font.color color
    , Font.size size
    , Font.family [ Font.typeface "Arial", Font.sansSerif ]
    , Element.paddingEach { left = padding, right = 0, top = 0, bottom = 0 }
    , Region.heading <| Basics.clamp 1 5 level
    ]
        ++ attributes


paragraph : Style -> List (Element.Attribute msg) -> List (Element.Attribute msg)
paragraph style attributes =
    [ Font.color <| fgColor style
    , Font.size 18
    , Font.family [ Font.typeface "Georgia", Font.serif ]
    , Font.alignLeft
    , Element.spacing 10
    ]
        ++ attributes


link : Style -> List (Element.Attribute msg) -> List (Element.Attribute msg)
link style attributes =
    [ Font.color <| linkColor style
    , Font.underline
    , Element.mouseDown [ Font.color <| linkPressColor style ]
    , Element.mouseOver [ Font.color <| linkFocusColor style ]
    , Element.focused [ Font.color <| linkFocusColor style ]
    ]
        ++ attributes


button : Style -> List (Element.Attribute msg) -> List (Element.Attribute msg)
button style attributes =
    [ Element.padding 13
    , Background.color <| buttonColor style
    , Font.color <| fgColor style
    , Font.family [ Font.typeface "Georgia", Font.serif ]
    , Element.mouseDown [ Background.color <| buttonPressColor style ]
    , Element.mouseOver [ Background.color <| buttonHoverColor style ]
    , Element.focused [ Background.color <| buttonHoverColor style ]
    ]
        ++ attributes


smallButton : Style -> List (Element.Attribute msg) -> List (Element.Attribute msg)
smallButton style attributes =
    [ Element.padding 10
    , Background.color <| smallButtonColor style
    , Font.color <| fgColor style
    , Font.family [ Font.typeface "Verdana", Font.sansSerif ]
    , Border.rounded 7
    , Element.mouseDown [ Background.color <| smallButtonPressColor style ]
    , Element.mouseOver [ Background.color <| smallButtonHoverColor style ]
    , Element.focused [ Background.color <| smallButtonHoverColor style ]
    ]
        ++ attributes



-- COLORS


bgColor : Style -> Color
bgColor style =
    case style of
        Dark ->
            rgb255 40 40 40

        Light ->
            rgb255 251 241 199


fgColor : Style -> Color
fgColor style =
    case style of
        Dark ->
            rgb255 251 241 199

        Light ->
            rgb255 40 40 40


fgFadedColor : Style -> Color
fgFadedColor style =
    case style of
        Dark ->
            rgb255 150 150 150

        Light ->
            rgb255 100 100 100


linkColor : Style -> Color
linkColor style =
    case style of
        Dark ->
            --rgb255 131 165 152
            rgb255 69 133 136

        Light ->
            rgb255 51 102 153


linkFocusColor : Style -> Color
linkFocusColor style =
    case style of
        Dark ->
            rgb255 109 173 176

        Light ->
            rgb255 81 132 203


linkPressColor : Style -> Color
linkPressColor style =
    case style of
        Dark ->
            rgb255 131 165 152

        Light ->
            rgb255 31 72 123


barColor : Style -> Color
barColor style =
    case style of
        Dark ->
            rgb255 66 165 70

        Light ->
            rgb255 231 83 24


buttonColor : Style -> Color
buttonColor style =
    case style of
        Dark ->
            rgb255 76 175 80

        Light ->
            rgb255 241 93 34


buttonHoverColor : Style -> Color
buttonHoverColor style =
    case style of
        Dark ->
            rgb255 92 207 96

        Light ->
            rgb255 255 123 54


buttonPressColor : Style -> Color
buttonPressColor style =
    case style of
        Dark ->
            rgb255 60 159 64

        Light ->
            rgb255 211 63 14


smallButtonColor : Style -> Color
smallButtonColor style =
    case style of
        Dark ->
            rgb255 50 50 50

        Light ->
            rgb255 241 231 189


smallButtonHoverColor : Style -> Color
smallButtonHoverColor style =
    case style of
        Dark ->
            rgb255 60 60 60

        Light ->
            rgb255 246 236 194


smallButtonPressColor : Style -> Color
smallButtonPressColor style =
    case style of
        Dark ->
            rgb255 45 45 45

        Light ->
            rgb255 236 226 184
