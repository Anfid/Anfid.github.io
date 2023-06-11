module Resume exposing (Msg, contentView, view)

import Browser
import Element exposing (Color, Element, alignTop, column, el, fill, paragraph, px, rgb255, row, textColumn, wrappedRow)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import ElementFix exposing (text)
import Html.Attributes


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
            [ Element.width <| px 100, Element.height <| px 100, Border.rounded 20, Element.clip ]
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
    textColumn attributes <| List.map (\p -> paragraph [] <| List.map text p) paragraphs


body : Element Msg
body =
    row [ Element.spacing 20, Element.width <| Element.minimum (lcolMinWidth + rcolWidth + 20) <| Element.maximum (lcolMaxWidth + rcolWidth + 20) <| fill ]
        [ column [ Element.width <| Element.minimum lcolMinWidth <| Element.maximum lcolMaxWidth fill, Element.spacing 35, alignTop ]
            [ bodyPart "About me" <|
                textColumnFromStrings (textStyle [ Element.width fill, Element.spacing 10 ])
                    [ [ "I'm a Rust engineer experienced in Rust, WebAssembly, UNIX and blockchain. My C/C++ embedded background provided me "
                      , "with deep understanding of how software works on the lowest level and how it interacts with hardware. During "
                      , "software development my main priority is it's reliability and security. I put in extra effort to make sure "
                      , "that it adheres to best practices and applicable open standards."
                      ]
                    , [ "I have significant experience in organizing work on a project and prioritizing key features and tasks. I "
                      , "proactively engage in discussions of what project or feature aims to achieve and what is required to "
                      , "implement it. This allows me to identify potential difficult points early on, provide swift feedback and "
                      , "set realistic goals or come up with a good compromise if resources are limited."
                      ]
                    , [ "And of course I always remain open to learning from other people or from my own experiences. I feel like this "
                      , "is a must for being a good developer in a rapidly-changing software development world."
                      ]
                    ]
            , bodyPart "Employment history" <|
                column [ Element.width fill, Element.spacing 20 ]
                    [ historyEntry
                        "Smart contract developer (Rust) at Bictory"
                        "January 2022 - October 2022"
                        "Remote"
                        (Just [ "Rust", "Smart Contracts", "WebAssembly", "Concordium", "API design" ])
                      <|
                        textColumnFromStrings (textStyle [ Element.width fill, paddingLeft 10, Element.spacing 7 ])
                            [ [ "Updated NFT project to adhere to Concordium blockchain interoperability standard CIS-1."
                              ]
                            , [ "Took full responsibility for designing and implementing name service smart contract for Concordium ecosystem and "
                              , "provided a flexible solution within strict time schedule despite unclear and fluctuating requirements. During my work "
                              , "on the name service I was able to provide stable documentation of future API and binary serialization format extremely "
                              , "early to allow the start of integration process and reduce overall project development time."
                              ]
                            , [ "All the work had to be done in a rapidly changing environment, some work-in-progress solutions had to be reworked "
                              , "swiftly due to blockchain updates."
                              ]
                            , [ "Aggressively optimized WebAssembly binaries for size to provide extensive functionality despite strict blockchain limitations."
                              ]
                            ]
                    , historyEntry
                        "Blockchain developer (Rust) at Gear"
                        "August 2021 - December 2021"
                        "Moscow, Russia"
                        (Just [ "Rust", "WebAssembly", "Substrate", "API design" ])
                      <|
                        textColumnFromStrings (textStyle [ Element.width fill, paddingLeft 10, Element.spacing 7 ])
                            [ [ "Provided library interface for smart contract development with safe and user-friendly abstractions over low-level functions "
                              , "exposed by smart contract platform."
                              ]
                            , [ "Greatly extended the functionality of smart contract test library and streamlined it's API."
                              ]
                            , [ "Implemented unit tests for existing functionality."
                              ]
                            ]
                    , historyEntry
                        "Blockchain developer (Rust) at XDSoft"
                        "September 2019 - March 2021"
                        "Novosibirsk, Russia"
                        (Just [ "Rust", "Tokio", "GitLab CI", "Exonum" ])
                      <|
                        textColumnFromStrings (textStyle [ Element.width fill, paddingLeft 10, Element.spacing 7 ])
                            [ [ "Implemented the intellectual property tracking system on top of the Exonum blockchain node."
                              ]
                            , [ "Updated consensus algorithm to improve node connectivity."
                              ]
                            , [ "Had to take over leading the project development urgently, was able to adapt to new responsibilities quickly and made "
                              , "sure that good quality product was delivered in time."
                              ]
                            , [ "Integrated cryptography library in accordance with certification requirements, provided necessary documentation for "
                              , "certification process."
                              ]
                            , [ "Set up and optimized GitLab CI test and build process for Rust project."
                              ]
                            ]
                    , historyEntry
                        "Embedded developer (C/C++) at MERA"
                        "March 2018 - September 2019"
                        "Nizhniy Novgorod, Russia"
                        (Just [ "C/C++", "Embedded", "Networking", "Buildroot", "RTOS" ])
                      <|
                        textColumnFromStrings (textStyle [ Element.width fill, paddingLeft 10, Element.spacing 7 ])
                            [ [ "Developed and maintained fire alarm and security systems on embedded devices running Linux and TreadX RTOS."
                              ]
                            , [ "Improved device network connection stability."
                              ]
                            , [ "Migrated legacy firmware to a device running RTOS."
                              ]
                            , [ "Researched networking standards and protocols to work on network switch firmware."
                              ]
                            ]
                    ]
            , bodyPart "Education" <|
                column [ Element.width fill ]
                    [ historyEntry
                        "Nizhniy Novgorod Technical College"
                        "October 2013 - October 2017"
                        "Nizhniy Novgorod, Russia"
                        Nothing
                      <|
                        column
                            [ paddingLeft 20 ]
                            [ paragraph (textStyle [])
                                [ text "" ]
                            ]
                    ]
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
                            { url = "mailto:mikhail.pogretskiy@gmail.com"
                            , label = el (extrasTextStyle [ Element.alignRight ]) <| text "mikhail.pogretskiy@gmail.com"
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


historyEntry : String -> String -> String -> Maybe (List String) -> Element Msg -> Element Msg
historyEntry title dates location skills content =
    column [ paddingLeft 10, Element.spacing 5, Element.width fill, Element.htmlAttribute <| Html.Attributes.style "break-inside" "avoid" ]
        [ paragraph
            [ Font.color fgColor, Font.size 17, Font.family [ Font.serif ], Font.bold ]
            [ text title ]
        , wrappedRow [ Element.width fill ]
            [ text dates |> el (textStyle [ Font.size 13, Font.color fgFadedColor, Element.alignLeft ])
            , text location |> el (textStyle [ Font.size 13, Font.color fgFadedColor, Element.alignRight ])
            ]
        , case skills of
            Just skillList ->
                wrappedRow
                    -- Padding = 3 fixes a stupid weird page print bug in chromium. No clue why. Do not remove
                    [ Element.padding 3, Element.spacing 5, Font.color fgColor, Font.size 13, Font.family [ Font.serif ], Font.bold, Element.alignLeft ]
                    (List.map (\skill -> el skillBadge (text skill)) skillList)

            Nothing ->
                Element.none
        , content
        ]


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
        , Font.size 16
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
