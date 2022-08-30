module Resume exposing (Msg, view)

import Browser
import Element exposing (Color, Element, alignTop, centerX, column, el, fill, fillPortion, paragraph, px, rgb255, row, spacing, width, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import ElementFix exposing (text)


type alias Msg =
    Browser.UrlRequest


view : Element Msg
view =
    column [ Element.width <| Element.minimum 570 <| fill, Element.padding 50, Element.spacing 50, Background.color bgColor ]
        [ heading
        , body
        ]


heading : Element Msg
heading =
    row [ Element.spacing 10, Element.width <| Element.minimum 470 <| fill ]
        [ Element.image
            [ Element.width <| px 100, Border.rounded 20, Element.clip ]
            { src = "/assets/resume_photo.png", description = "Photo" }
        , column []
            [ el [ Element.padding 5, Font.color fgColor, Font.size 40, Font.family [ Font.serif ] ] <|
                text "Mikhail Pogretskiy"
            , el (textStyle []) <| text "Rust developer"
            ]
        ]


body : Element Msg
body =
    row [ Element.spacing 20, Element.width <| Element.minimum (250 + 200 + 20) <| Element.maximum (1000 + 250 + 20) <| fill ]
        [ column [ Element.width <| Element.minimum 250 <| Element.maximum 1000 <| fillPortion 2, Element.spacing 25, alignTop ]
            [ bodyPart "Profile" <|
                paragraph
                    (textStyle [ Font.justify ])
                    [ text profileText ]
            , bodyPart "Employment history" <|
                column [ Element.width fill, Element.spacing 10 ]
                    [ historyEntry
                        "Smart contract developer (Rust) at Bictory"
                        "January 2022 - Present"
                        "Remote"
                      <|
                        Element.column
                            [ Element.paddingEach { left = 20, right = 0, top = 0, bottom = 0 } ]
                            [ paragraph (textStyle [])
                                [ text "Designing, implementing, documenting and integrating Concordium smart contracts for:" ]
                            , paragraph (textStyle [])
                                [ text "• Concordium name service" ]
                            , paragraph (textStyle [])
                                [ text "• Bictory NFT" ]
                            , paragraph (textStyle [])
                                [ text "• Data storage" ]
                            ]
                    , historyEntry
                        "Blockchain developer (Rust) at Gear"
                        "August 2021 - December 2021"
                        "Moscow, Russia"
                      <|
                        Element.column
                            [ Element.paddingEach { left = 20, right = 0, top = 0, bottom = 0 } ]
                            [ paragraph (textStyle [])
                                [ text "Developing and maintaining Gear, a Substrate smart contract platform for Polkadot" ]
                            , paragraph (textStyle [])
                                [ text "Creating smart contract library API" ]
                            , paragraph (textStyle [])
                                [ text "Extending smart contract test library" ]
                            ]
                    , historyEntry
                        "Blockchain developer (Rust) at XDSoft"
                        "September 2019 - March 2021"
                        "Novosibirsk, Russia"
                      <|
                        Element.column
                            [ Element.paddingEach { left = 20, right = 0, top = 0, bottom = 0 } ]
                            [ paragraph (textStyle [])
                                [ text "Developing Exonum blockchain framework fork with private transactions and GOST cryptography" ]
                            , paragraph (textStyle [])
                                [ text "Translating business requirements to granular tasks" ]
                            , paragraph (textStyle [])
                                [ text "Creating automation scripts and setting up GitLab CI" ]
                            , paragraph (textStyle [])
                                [ text "Creating tasks, distributing them to team members, reviewing code and maintaining documentation" ]
                            ]
                    , historyEntry
                        "Embedded developer (C/C++) at MERA"
                        "March 2018 - September 2019"
                        "Nizhniy Novgorod, Russia"
                      <|
                        column
                            [ Element.paddingEach { left = 20, right = 0, top = 0, bottom = 0 } ]
                            [ paragraph (textStyle [])
                                [ text "Developing and maintaining Linux and RTOS embedded security systems" ]
                            , paragraph (textStyle [])
                                [ text "Improving device network connection stability" ]
                            ]
                    ]
            , bodyPart "Education" <|
                column [ Element.width fill ]
                    [ historyEntry
                        "Nizhniy Novgorod Technical College"
                        "October 2013 - October 2017"
                        "Nizhniy Novgorod, Russia"
                      <|
                        column
                            [ Element.paddingEach { left = 20, right = 0, top = 0, bottom = 0 } ]
                            [ paragraph (textStyle [])
                                [ text "" ]
                            ]
                    ]
            ]
        , column [ Element.width <| Element.maximum 250 <| Element.minimum 200 <| fillPortion 1, Element.spacing 15, alignTop ]
            [ extraEntry "Contacts" <|
                Element.column
                    []
                    [ el (extrasTextStyle [ Font.bold ]) <| text "E-mail"
                    , Element.link []
                        { url = "mailto:mikhail.pogretskiy@gmail.com"
                        , label = el (extrasTextStyle [ Element.alignRight ]) <| text "mikhail.pogretskiy@gmail.com"
                        }
                    , el (extrasTextStyle [ Font.bold ]) <| text "Telegram"
                    , el (extrasTextStyle []) <| text "@Anfid"
                    , el (extrasTextStyle [ Font.bold ]) <| text "Mobile"
                    , el (extrasTextStyle []) <| text "+995 (595) 46 56 29"
                    ]
            , extraEntry "Date/Place of birth" <|
                paragraph
                    (extrasTextStyle [ Element.spacing 5 ])
                    [ text "22.07.1997, Russia" ]
            , extraEntry "Website" <|
                Element.link
                    (extrasTextStyle [ Element.spacing 5 ])
                    { url = "https://Anfid.github.io/"
                    , label = el (extrasTextStyle [ Element.alignRight ]) <| text "Anfid.github.io"
                    }
            , extraEntry "Links" <|
                Element.link
                    (extrasTextStyle [ Element.spacing 5 ])
                    { url = "https://github.com/Anfid"
                    , label =
                        row []
                            [ Element.image [ Element.width <| px 15 ] { src = "/assets/GitHub-Mark-32px.png", description = "GitHub logo" }
                            , el (extrasTextStyle [ Element.alignRight ]) <| text "Anfid"
                            ]
                    }
            , extraEntry "Programming languages" <|
                column
                    (extrasTextStyle [ Element.spacing 5 ])
                    [ el [] <| text "Rust"
                    , el [] <| text "Elm"
                    , el [] <| text "Lua"
                    , el [] <| text "C"
                    ]
            , extraEntry "Skills" <|
                column
                    (extrasTextStyle [ Element.spacing 5 ])
                    [ el [] <| text "*NIX"
                    , el [] <| text "Git"
                    , el [] <| text "WASM"
                    , el [] <| text "x86 ASM"
                    ]
            , extraEntry "Languages" <|
                column
                    (extrasTextStyle [ Element.width fill, Element.spacing 5 ])
                    [ row [ Element.width fill ] [ text "Russian", el [ Element.alignRight, Font.color fgFadedColor ] <| text "Native" ]
                    , row [ Element.width fill ] [ text "English", el [ Element.alignRight, Font.color fgFadedColor ] <| text "Fluent" ]
                    ]
            ]
        ]


bodyPart : String -> Element Msg -> Element Msg
bodyPart title content =
    column [ Element.width fill ]
        [ paragraph
            [ Element.padding 5, Font.color fgColor, Font.size 22, Font.family [ Font.serif ], Font.bold ]
            [ text title ]
        , content
        ]


historyEntry : String -> String -> String -> Element Msg -> Element Msg
historyEntry title dates location content =
    column [ Element.paddingEach { left = 20, right = 0, top = 0, bottom = 0 }, Element.width fill ]
        [ paragraph
            [ Element.padding 5, Font.color fgColor, Font.size 18, Font.family [ Font.serif ], Font.bold ]
            [ text title ]
        , wrappedRow [ Element.width fill ]
            [ text dates |> el (textStyle [ Font.size 14, Font.color fgFadedColor, Element.alignLeft ])
            , text location |> el (textStyle [ Font.size 14, Font.color fgFadedColor, Element.alignRight ])
            ]
        , content
        ]


extraEntry : String -> Element Msg -> Element Msg
extraEntry title content =
    column [ Element.width fill ]
        [ paragraph [ Element.padding 5, Font.bold, Font.color fgColor, Font.size 18, Font.family [ Font.serif ] ] [ text title ]
        , el [ Element.width fill, Element.paddingEach { left = 10, right = 0, top = 0, bottom = 0 } ] content
        ]


profileText : String
profileText =
    "Software developer with passion for building reliable and efficient software, experienced "
        ++ "with Rust, *NIX and blockchain. I love collaborating with other developers to discuss "
        ++ "various approaches to complex problems to provide the best solution and learn from "
        ++ "other people's experiences."



-- STYLE


textStyle : List (Element.Attribute msg) -> List (Element.Attribute msg)
textStyle =
    (++)
        [ Element.padding 5
        , Font.color fgColor
        , Font.size 18
        , Font.family [ Font.serif ]
        ]


extrasTextStyle : List (Element.Attribute msg) -> List (Element.Attribute msg)
extrasTextStyle =
    (++)
        [ Element.padding 5
        , Font.color fgColor
        , Font.size 14
        , Font.family [ Font.serif ]
        ]



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
