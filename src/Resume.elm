module Resume exposing (Msg, contentView, view)

import Browser
import Date exposing (Date)
import Element exposing (Color, Element, alignTop, column, el, fill, paragraph, px, rgb255, row, textColumn, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import ElementExt exposing (text)
import Experience exposing (EmploymentEntry)
import Html.Attributes
import Time exposing (Month(..))


type alias Msg =
    Browser.UrlRequest


view : Element Msg
view =
    el [ Element.padding 50, Background.color bgColor ] contentView


contentView : Element Msg
contentView =
    column [ Element.width <| Element.minimum 520 <| fill, Element.spacing 30, Background.color bgColor ]
        [ heading
        , body
        ]


heading : Element Msg
heading =
    row [ Element.spacing 20, Element.width <| Element.minimum 470 <| fill ]
        [ Element.image
            [ Element.width <| px 100, Element.height <| px 100, Border.rounded 20, Element.clip, Background.image "/assets/resume_photo_smol.jpeg" ]
            { src = "/assets/resume_photo.png", description = "" }
        , column [ Element.spacing 5 ]
            [ el [ Font.color fgColor, Font.size 40, Font.family [ Font.serif ] ] <|
                text "Mikhail Pogretskiy"
            , el (textStyle []) <| text "Rust developer"
            ]
        ]


lcolMinWidth : Int
lcolMinWidth =
    250


lcolMaxWidth : Int
lcolMaxWidth =
    1000


rcolWidth : Int
rcolWidth =
    200


textColumnFromStrings : List (Element.Attribute Msg) -> List (List String) -> Element Msg
textColumnFromStrings attributes paragraphs =
    textColumn attributes <| List.map (\p -> paragraph [ Element.spacing 2 ] <| List.map text p) paragraphs


body : Element Msg
body =
    row [ Element.spacing 20, Element.width <| Element.minimum (lcolMinWidth + rcolWidth + 20) <| Element.maximum (lcolMaxWidth + rcolWidth + 20) <| fill ]
        [ column [ Element.width <| Element.minimum lcolMinWidth <| Element.maximum lcolMaxWidth fill, Element.spacing 35, alignTop ]
            [ bodyPart "About me" <|
                textColumnFromStrings (textStyle [ Element.width fill, Element.spacing 5 ]) Experience.about
            , bodyPart "Employment history" <|
                column [ Element.width fill, Element.spacing 20 ] <|
                    List.map employmentToHistory <|
                        List.reverse <|
                            List.sortBy (\e -> Date.toRataDie e.start) Experience.employmentList
            ]
        , column [ Element.width <| px rcolWidth, Element.spacing 30, alignTop ]
            [ extraEntry "Skills" <|
                skillColumns
                    [ "Rust"
                    , "WebAssembly"
                    , "Substrate"
                    , "Smart Contracts"
                    , "Blockchain"
                    , "Linux"
                    , "UNIX"
                    ]
                    [ "API design"
                    , "Git"
                    , "GitLab CI"
                    , "Tokio"
                    , "x86 ASM"
                    , "Elm"
                    , "Python"
                    , "Lua"
                    , "C"
                    ]
            , extraEntry "Contacts" <|
                Element.column
                    [ Element.spacing 9, paddingLeft 5 ]
                    [ Element.column
                        [ Element.spacing 3 ]
                        [ el (extrasTextStyle [ Font.bold ]) <| text "E-mail"
                        , Element.link []
                            { url = "mailto:mikhail@anfid.net"
                            , label = el (extrasTextStyle [ Element.alignRight ]) <| text "mikhail@anfid.net"
                            }
                        ]
                    , Element.column
                        [ Element.spacing 3 ]
                        [ el (extrasTextStyle [ Font.bold ]) <| text "Telegram"
                        , Element.link []
                            { url = "https://t.me/anfid"
                            , label = el (extrasTextStyle []) <| text "@Anfid"
                            }
                        ]
                    , Element.column
                        [ Element.spacing 3 ]
                        [ el (extrasTextStyle [ Font.bold ]) <| text "Mobile"
                        , el (extrasTextStyle []) <| text "+995 (595) 46 56 29"
                        ]
                    ]
            , extraEntry "Location" <|
                paragraph
                    (extrasTextStyle [ paddingLeft 5 ])
                    [ text "Tbilisi, Georgia" ]
            , extraEntry "Website" <|
                Element.link
                    (extrasTextStyle [])
                    { url = "https://anfid.github.io/"
                    , label = el (extrasTextStyle [ paddingLeft 5 ]) <| text "anfid.github.io"
                    }
            , extraEntry "Links" <|
                Element.link
                    (extrasTextStyle [])
                    { url = "https://github.com/Anfid"
                    , label =
                        row [ paddingLeft 5, Element.spacing 5 ]
                            [ Element.image [ Element.width <| px 15 ] { src = "/assets/GitHub-Mark-32px.png", description = "GitHub logo" }
                            , el (extrasTextStyle []) <| text "Anfid"
                            ]
                    }
            , extraEntry "Languages" <|
                column
                    (extrasTextStyle [ Element.width fill, Element.spacing 5, paddingLeft 5 ])
                    [ row [ Element.width fill ] [ text "English", el [ Element.alignRight, Font.color fgFadedColor ] <| text "Fluent" ]
                    , row [ Element.width fill ] [ text "Russian", el [ Element.alignRight, Font.color fgFadedColor ] <| text "Native" ]
                    , row [ Element.width fill ] [ text "Spanish", el [ Element.alignRight, Font.color fgFadedColor ] <| text "Basic" ]
                    ]
            ]
        ]


bodyPart : String -> Element Msg -> Element Msg
bodyPart title content =
    column [ Element.width fill, Element.spacing 5 ]
        [ paragraph
            [ Font.color fgColor, Font.size 20, Font.family [ Font.serif ], Font.bold ]
            [ text title ]
        , content
        ]


historyEntry : String -> String -> String -> List String -> Element Msg -> Element Msg
historyEntry title dates location skills content =
    column [ paddingLeft 10, Element.spacing 5, Element.width fill, Element.htmlAttribute <| Html.Attributes.style "break-inside" "avoid" ]
        [ paragraph
            [ Font.color fgColor, Font.size 17, Font.family [ Font.serif ], Font.bold ]
            [ text title ]
        , wrappedRow [ Element.width fill ]
            [ text dates |> el (textStyle [ Font.size 13, Font.color fgFadedColor, Element.alignLeft ])
            , text location |> el (textStyle [ Font.size 13, Font.color fgFadedColor, Element.alignRight ])
            ]
        , if List.isEmpty skills then
            Element.none

          else
            wrappedRow
                -- Padding = 3 fixes a stupid weird page print bug in chromium. No clue why. Do not remove
                [ Element.padding 3, Element.spacing 5, Font.color fgColor, Font.size 13, Font.family [ Font.serif ], Font.bold, Element.alignLeft ]
                (List.map (\skill -> el skillBadge (text skill)) skills)
        , content
        ]


employmentToHistory : EmploymentEntry -> Element Msg
employmentToHistory entry =
    historyEntry
        (entry.role ++ " at " ++ entry.company)
        (formatDateRange entry.start entry.end)
        entry.location
        entry.skills
        (textColumnFromStrings (textStyle [ Element.width fill, paddingLeft 10, Element.spacing 5 ]) entry.description)


formatDateRange : Date -> Maybe Date -> String
formatDateRange start maybeEnd =
    Date.format "MMMM y" start
        ++ " - "
        ++ (case maybeEnd of
                Just end ->
                    Date.format "MMMM y" end

                Nothing ->
                    "Present"
           )


extraEntry : String -> Element Msg -> Element Msg
extraEntry title content =
    column [ Element.spacing 7, Element.width fill ]
        [ paragraph [ Font.bold, Font.color fgColor, Font.size 17, Font.family [ Font.serif ] ] [ text title ]
        , el [ Element.width fill ] content
        ]


skillColumns : List String -> List String -> Element Msg
skillColumns relevant secondary =
    let
        totalLength =
            List.length relevant + List.length secondary

        leftLength =
            totalLength // 2 + modBy 2 totalLength

        relevantFormatted =
            List.map (el (Font.bold :: skillBadge) << text) relevant

        secondaryFormatted =
            List.map (el skillBadge << text) secondary

        joined =
            List.append relevantFormatted secondaryFormatted
    in
    row (extrasTextStyle [ Element.width fill ]) <|
        [ column [ Element.alignTop, Element.alignLeft, Element.spacing 5 ] <|
            List.take leftLength
                joined
        , column [ Element.alignTop, Element.alignRight, Element.spacing 5 ] <|
            List.drop leftLength
                joined
        ]



-- STYLE


textStyle : List (Element.Attribute msg) -> List (Element.Attribute msg)
textStyle =
    (++)
        [ Font.color fgColor
        , Font.size 14
        , Font.family [ Font.serif ]
        ]


extrasTextStyle : List (Element.Attribute msg) -> List (Element.Attribute msg)
extrasTextStyle =
    (++)
        [ Font.color fgColor
        , Font.size 13
        , Font.family [ Font.serif ]
        ]


paddingLeft : Int -> Element.Attribute msg
paddingLeft pad =
    Element.paddingEach { left = pad, top = 0, right = 0, bottom = 0 }


skillBadge : List (Element.Attribute msg)
skillBadge =
    [ Element.padding 4, Background.color <| rgb255 235 235 235, Border.rounded 5 ]



-- COLORS


bgColor : Color
bgColor =
    rgb255 255 255 255


fgColor : Color
fgColor =
    rgb255 40 40 40


fgFadedColor : Color
fgFadedColor =
    rgb255 100 100 100
