module Projects exposing (Msg, view)

import Browser
import Element exposing (Element, column, fill, px)
import Element.Font as Font
import ElementExt exposing (chapter, link, text)
import Styles exposing (Style)


type alias Msg =
    Browser.UrlRequest


view : Style -> Element Msg
view style =
    column [ Element.width <| Element.maximum 900 fill, Element.paddingEach { top = 0, right = 20, bottom = 50, left = 20 }, Element.spacing 80, Element.centerX ]
        [ chapter "Rust"
            style
            1
            [ chapter "Mandelbrot"
                style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.image
                        [ Element.width <| px 200, Element.alignRight, Element.padding 5 ]
                        { src = "https://raw.githubusercontent.com/Anfid/media/master/Minibrot.png", description = "Mandelbrot zoom-in screenshot" }
                    , Element.row [ Element.spacing 20 ]
                        [ liveDemoButton style "/projects/mandelbrot/index.html"
                        , sourceButton style "https://github.com/Anfid/mandelbrot"
                        ]
                    , techStack style [ "Rust", "WASM", "WebGPU", "WGSL" ]
                    , Element.paragraph (Styles.paragraph style [])
                        [ text <|
                            "Mandelbrot set visualization powered by WebGPU. Since technology is very young, browser "
                                ++ "and driver support may be limited. For an up-to-date list of browsers that support "
                                ++ "WebGPU, see "
                        , link style "this MDN doc" "https://developer.mozilla.org/en-US/docs/Web/API/WebGPU_API#browser_compatibility"
                        , text "."
                        ]
                    ]
                ]
            , chapter "dnd-stuff"
                style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.image
                        [ Element.width <| px 200, Element.alignRight, Element.padding 5 ]
                        { src = "/assets/projects/dnd-stuff_demo.jpg", description = "dnd-stuff screenshot" }
                    , Element.row [ Element.spacing 20 ]
                        [ liveDemoButton style "/projects/dnd-stuff/index.html"
                        , sourceButton style "https://github.com/Anfid/dnd-stuff"
                        ]
                    , techStack style [ "Rust", "WASM", "Elm" ]
                    , Element.paragraph (Styles.paragraph style [])
                        [ text "An Elm + Rust web project inspired by "
                        , link style "rumkin.com/reference/dnd/diestats.php" "http://rumkin.com/reference/dnd/diestats.php"
                        , text <|
                            ". It shows probabilities of getting each value with specified dice combination. "
                                ++ "I was disappointed that it was practically impossible to see probabilities for "
                                ++ "more complex combinations due to poor performance and decided to try and create "
                                ++ "probabitity calculator with best performance possible."
                        ]
                    , Element.paragraph (Styles.paragraph style [])
                        [ text <|
                            "This project uses Elm for page rendering and Rust library compiled into WASM "
                                ++ "for performance-sensitive calculations. Minimal necessary JS glue-code is confined "
                                ++ "to index.html file."
                        ]
                    ]
                ]
            , chapter "coppe-wm"
                style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.image
                        [ Element.width <| px 300, Element.alignRight, Element.padding 15 ]
                        { src = "/assets/projects/coppe_demo.jpg", description = "coppe-wm screenshot" }
                    , Element.row [ Element.spacing 20 ] [ sourceButton style "https://github.com/Anfid/coppe-wm" ]
                    , techStack style [ "Rust", "Linux", "WASM", "X11", "libxcb" ]
                    , Element.paragraph (Styles.paragraph style [])
                        [ text <|
                            "Window manager for X11 fully configurable with standalone WASM plugins. It is "
                                ++ "intended to be as feature-rich as possible, but only the most basic functionality "
                                ++ "is implemented at the moment."
                        ]
                    ]
                ]
            , chapter "water"
                style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.row [ Element.spacing 20 ] [ sourceButton style "https://github.com/Anfid/water" ]
                    , techStack style [ "Rust", "cpal", "midir" ]
                    , Element.paragraph (Styles.paragraph style [])
                        [ text <|
                            "A simple Rust synthesyser for a MIDI keyboard. Currenly only CLI is available,"
                                ++ "UI is unimplemented. It is able to produce square sound wave with correct frequency "
                                ++ "for each key pressed."
                        ]
                    ]
                ]
            ]
        , chapter "C++"
            style
            1
            [ chapter "GItask"
                style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.image
                        [ Element.width <| px 300, Element.alignRight, Element.padding 15 ]
                        { src = "/assets/projects/GItask_demo.jpg", description = "GItask screenshot" }
                    , Element.row [ Element.spacing 20 ] [ sourceButton style "https://github.com/Anfid/GItask" ]
                    , techStack style [ "C++", "SDL", "CMake" ]
                    , Element.paragraph (Styles.paragraph style [])
                        [ text "Small isometric C++ game written on SDL. Although project is very old, it is a fun demo still."
                        ]
                    ]
                ]
            ]
        , chapter "Elm"
            style
            1
            [ chapter "Anfid.github.io"
                style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.row [ Element.spacing 20 ] [ sourceButton style "https://github.com/Anfid/Anfid.github.io" ]
                    , techStack style [ "Elm", "elm-ui" ]
                    , Element.paragraph (Styles.paragraph style [])
                        [ text "Well, it's this page." ]
                    ]
                ]
            ]
        ]


techStack : Style -> List String -> Element Msg
techStack style stack =
    Element.column [ Element.spacing 10, Element.padding 5 ] <|
        (Element.el (Styles.heading style 3 []) <| text "Stack")
            :: List.map (\el -> Element.row (Styles.paragraph style [ Element.paddingXY 25 0, Element.spacing 10 ]) [ Element.el [] <| text "•", Element.el [] <| text el ]) stack


sourceButton : Style -> String -> Element Msg
sourceButton style url =
    smallMonochromeIconButton style "/assets/GitHub-Mark-32px.png" "GitHub logo" "Source" url


liveDemoButton : Style -> String -> Element Msg
liveDemoButton style url =
    smallMonochromeIconButton style "/assets/play-button-arrowhead.png" "Live demo icon" "Live demo" url


smallMonochromeIconButton : Style -> String -> String -> String -> String -> Element Msg
smallMonochromeIconButton style logo desc buttonText url =
    Element.link (Styles.smallButton style [ Font.size 19 ])
        { label =
            Element.row [ Element.spacing 10 ]
                [ Element.image
                    (Styles.icon style [ Element.width <| px 17, Element.height <| px 17 ])
                    { src = logo, description = desc }
                , Element.el [] <| text buttonText
                ]
        , url = url
        }
