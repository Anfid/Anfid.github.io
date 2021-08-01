module Styles exposing (Style(..), bar, bgColor, button, heading, link, paragraph)

import Element exposing (Color, fill, rgb255)
import Element.Background as Background
import Element.Font as Font
import Element.Region as Region


type Style
    = Dark
    | Light



-- STYLES


bar : Style -> List (Element.Attribute msg) -> List (Element.Attribute msg)
bar style attributes =
    [ Element.width fill, Background.color <| barColor style ]
        ++ attributes


heading : Style -> Int -> List (Element.Attribute msg) -> List (Element.Attribute msg)
heading style level attributes =
    [ Font.color <| fgColor style
    , Font.size (20 + 12 // level)
    , Font.family [ Font.serif ]
    , Element.paddingEach { left = 15, right = 0, top = 0, bottom = 0 }
    , Region.heading level
    ]
        ++ attributes


paragraph : Style -> List (Element.Attribute msg) -> List (Element.Attribute msg)
paragraph style attributes =
    [ Font.color <| fgColor style
    , Font.size 18
    , Font.family [ Font.serif ]
    , Font.justify
    ]
        ++ attributes


link : Style -> List (Element.Attribute msg)
link style =
    [ Font.color <| linkColor style
    , Font.size 18
    , Font.family [ Font.serif ]
    , Font.underline
    , Element.mouseDown [ Font.color <| linkPressColor style ]
    , Element.mouseOver [ Font.color <| linkFocusColor style ]
    , Element.focused [ Font.color <| linkFocusColor style ]
    ]


button : Style -> List (Element.Attribute msg) -> List (Element.Attribute msg)
button style attributes =
    [ Element.padding 13
    , Background.color <| buttonColor style
    , Font.color <| fgColor style
    , Font.family [ Font.serif ]
    , Element.mouseDown [ Background.color <| buttonPressColor style ]
    , Element.mouseOver [ Background.color <| buttonHoverColor style ]
    , Element.focused [ Background.color <| buttonHoverColor style ]
    ]
        ++ attributes



-- COLORS


bgColor : Style -> Color
bgColor style =
    case style of
        Dark ->
            rgb255 40 40 40

        Light ->
            rgb255 255 255 255


fgColor : Style -> Color
fgColor style =
    case style of
        Dark ->
            rgb255 255 255 255

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
