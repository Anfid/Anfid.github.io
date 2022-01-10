module Main exposing (main)

import Browser
import Browser.Navigation as Navigation
import Element exposing (Element, column, fill, px, text)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html.Attributes
import Ports
import Resume
import Styles exposing (Style)
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)



-- MAIN


main : Program Dimensions Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        , subscriptions = subscriptions
        }


init : Dimensions -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init keys url key =
    ( gotoUrl url <| Model key keys url Styles.Dark Index, Cmd.none )



-- MODEL


type alias Model =
    { key : Navigation.Key
    , dimensions : Dimensions
    , url : Url
    , style : Style
    , page : Page
    }


type Page
    = Index
    | Resume
    | ResumeExport
    | Projects
    | NotFound


type alias Dimensions =
    { width : Int
    , height : Int
    }



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Resize Int Int
    | Goto String
    | ResumeMsg Resume.Msg
    | Print


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Navigation.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            ( gotoUrl url model, Cmd.none )

        Print ->
            ( model, Ports.printPage )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "Anfid.github.io"
    , body =
        [ Element.layout
            [ Background.color <| Styles.bgColor model.style, Element.scrollbarY, Element.height fill, Element.width fill ]
            (body model)
        ]
    }


body : Model -> Element Msg
body model =
    case model.page of
        Index ->
            column [ Element.width fill, Element.height fill, Element.spacing 30 ]
                [ bar model []
                , index model
                ]

        Resume ->
            column [ Element.width <| Element.minimum 570 fill, Element.spacing 50 ]
                [ bar model [ Element.link (Styles.button model.style []) { url = "/resume/export", label = text "Export/Print" } ]
                , Element.el
                    [ Element.width <| Element.minimum 570 <| Element.maximum 800 fill, Element.centerX ]
                  <|
                    Element.map LinkClicked Resume.view
                ]

        ResumeExport ->
            Element.el
                [ Element.width fill
                , Element.height fill
                , Element.inFront <|
                    Input.button
                        (Styles.button model.style
                            [ notPrintable
                            , Element.alignRight
                            , Border.roundEach { topLeft = 0, topRight = 0, bottomLeft = 50, bottomRight = 0 }
                            ]
                        )
                        { onPress = Just Print
                        , label =
                            Element.el
                                [ Element.paddingEach { left = 25, right = 10, top = 5, bottom = 15 }
                                , Font.size 25
                                ]
                                (text "Print")
                        }
                ]
            <|
                Element.el
                    [ Element.width fill
                    , Element.height fill
                    , Element.scrollbars
                    , Element.alignLeft
                    ]
                <|
                    Element.map LinkClicked <|
                        Resume.view

        Projects ->
            column [ Element.width fill, Element.height fill, Element.spacing 30 ]
                [ bar model []
                , projects model
                ]

        NotFound ->
            Element.column [ Element.spacing 70, Element.centerX, Element.centerY ]
                [ Element.el (Styles.paragraph model.style [ Font.size 100, Element.centerX ]) <| text "404"
                , Element.el (Styles.paragraph model.style [ Font.size 50, Element.centerX ]) <| text "Not Found"
                , Element.link (Styles.button model.style [ Element.centerX ]) { label = Element.paragraph [] [ text "Let's go home?" ], url = "/" }
                ]



-- elements


bar : Model -> List (Element Msg) -> Element Msg
bar model contextActions =
    Element.row (Styles.bar model.style [])
        [ Element.link (Styles.button model.style []) { url = "/", label = text "Home" }
        , Element.link (Styles.button model.style []) { url = "/projects", label = text "Projects" }
        , Element.link (Styles.button model.style []) { url = "/resume", label = text "Resume" }
        , Element.row [ Element.alignRight ] contextActions
        ]


index : Model -> Element Msg
index model =
    column [ Element.width <| Element.maximum 900 fill, Element.paddingXY 50 0, Element.spacing 50, Element.centerX ]
        [ Element.paragraph (Styles.paragraph model.style [])
            [ text "Hello, my name is Mikhail Pogretskiy. I am Rust software developer, and this page is created as a "
            , text "general overview of my software development background."
            ]
        , chapter "Navigation"
            model.style
            1
            [ Element.paragraph (Styles.paragraph model.style [])
                [ link model.style "resume" "/resume", text " (", link model.style "export/print view" "/resume/export", text ")" ]
            , Element.paragraph (Styles.paragraph model.style [])
                [ link model.style "projects" "/projects" ]
            ]
        , chapter "About me"
            model.style
            1
            [ Element.paragraph (Styles.paragraph model.style [])
                [ text "Although my primary commercial Rust experience is related to blockchain and "
                , text "Exonum blockchain framework, I extend my knowledge in other areas by creating personal "
                , text "pet-projects with various level of polishness. They are usually limited to technical demos "
                , text "due to lack of time and amount of these projects. See "
                , link model.style "projects" "/projects"
                , text " for more info."
                ]
            , Element.paragraph (Styles.paragraph model.style [])
                [ text "I have experience in creating and designing multithreaded systems, enjoy writing portable, "
                , text "highly optimized code."
                ]
            ]
        ]


projects : Model -> Element Msg
projects model =
    column [ Element.width <| Element.maximum 900 fill, Element.paddingXY 50 0, Element.spacing 80, Element.centerX ]
        [ chapter "Rust"
            model.style
            1
            [ chapter "dnd-stuff"
                model.style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.image
                        [ Element.width <| px 200, Element.alignRight, Element.padding 15 ]
                        { src = "/assets/projects/dnd-stuff_demo.jpg", description = "dnd-stuff screenshot" }
                    , Element.link (Styles.link model.style [ Element.paddingXY 20 0, Font.size 20 ]) { label = text "Source", url = "https://github.com/Anfid/dnd-stuff" }
                    , techStack model.style [ "Rust", "WASM", "Elm" ]
                    , Element.paragraph (Styles.paragraph model.style [])
                        [ text "An Elm + Rust web project inspired by "
                        , link model.style "rumkin.com/reference/dnd/diestats.php" "http://rumkin.com/reference/dnd/diestats.php"
                        , text ". It shows probabilities of getting each value with specified dice combination. "
                        , text "I was disappointed that it was practically impossible to see probabilities for "
                        , text "more complex combinations due to poor performance and decided to try and create "
                        , text "probabitity calculator with best performance possible."
                        ]
                    , Element.paragraph (Styles.paragraph model.style [])
                        [ text "This project uses Elm for page rendering and Rust library compiled into WASM "
                        , text "for performance-sensitive calculations. Minimal necessary JS glue-code is confined "
                        , text "to index.html file."
                        ]
                    ]
                ]
            , chapter "coppe-wm"
                model.style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.image
                        [ Element.width <| px 300, Element.alignRight, Element.padding 15 ]
                        { src = "/assets/projects/coppe_demo.jpg", description = "coppe screenshot" }
                    , Element.link (Styles.link model.style [ Element.paddingXY 20 0, Font.size 20 ]) { label = text "Source", url = "https://github.com/Anfid/coppe-wm" }
                    , techStack model.style [ "Rust", "Linux", "WASM", "X11", "libxcb" ]
                    , Element.paragraph (Styles.paragraph model.style [])
                        [ text "Window manager for X11 fully configurable with standalone WASM plugins. It is "
                        , text "intended to be as feature-rich as possible, but only the most basic functionality "
                        , text "is implemented at the moment."
                        ]
                    ]
                ]
            , chapter "water"
                model.style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.link (Styles.link model.style [ Element.paddingXY 20 0, Font.size 20 ]) { label = text "Source", url = "https://github.com/Anfid/water" }
                    , techStack model.style [ "Rust", "cpal", "midir" ]
                    , Element.paragraph (Styles.paragraph model.style [])
                        [ text "A simple Rust synthesyser for a MIDI keyboard. Currenly only CLI is available,"
                        , text "UI is unimplemented. It is able to produce square sound wave with correct frequency "
                        , text "for each key pressed."
                        ]
                    ]
                ]
            ]
        , chapter "C++"
            model.style
            1
            [ chapter "GItask"
                model.style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.image
                        [ Element.width <| px 300, Element.alignRight, Element.padding 15 ]
                        { src = "/assets/projects/GItask_demo.jpg", description = "GItask screenshot" }
                    , Element.link (Styles.link model.style [ Element.paddingXY 20 0, Font.size 20 ]) { label = text "Source", url = "https://github.com/Anfid/GItask" }
                    , techStack model.style [ "C++", "SDL", "CMake" ]
                    , Element.paragraph (Styles.paragraph model.style [])
                        [ text "Small isometric C++ game written on SDL. Although project is very old, it is a "
                        , text "fun demo still."
                        ]
                    ]
                ]
            ]
        , chapter "Elm"
            model.style
            1
            [ chapter "Anfid.github.io"
                model.style
                2
                [ Element.textColumn [ Element.spacing 15, Element.width fill ]
                    [ Element.link (Styles.link model.style [ Element.paddingXY 20 0, Font.size 20 ]) { label = text "Source", url = "https://github.com/Anfid/Anfid.github.io" }
                    , techStack model.style [ "Elm", "elm-ui" ]
                    , Element.paragraph (Styles.paragraph model.style [])
                        [ text "Well, it's this page." ]
                    ]
                ]
            ]
        ]


techStack : Style -> List String -> Element Msg
techStack style stack =
    Element.column [ Element.spacing 10, Element.padding 5 ] <|
        (Element.el (Styles.heading style 3 []) <| text "Stack")
            :: List.map (\el -> Element.el (Styles.paragraph style [ Element.paddingXY 25 0 ]) <| text <| "• " ++ el) stack


chapter : String -> Style -> Int -> List (Element Msg) -> Element Msg
chapter heading style level content =
    Element.column [ Element.width fill, Element.height fill, Element.spacing 30, Element.padding 10 ] <|
        [ Element.paragraph (Styles.heading style level []) <|
            [ text heading ]
        ]
            ++ content


link : Style -> String -> String -> Element Msg
link style label url =
    Element.link (Styles.link style []) { label = Element.paragraph [] [ text label ], url = url }



--styles


notPrintable : Element.Attribute Msg
notPrintable =
    Element.htmlAttribute <| Html.Attributes.class "noprint"



-- ROUTER


type Route
    = IndexRoute
    | ResumeRoute
    | ResumeExportRoute
    | ProjectsRoute


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map IndexRoute Parser.top
        , Parser.map ResumeRoute (Parser.s "resume")
        , Parser.map ResumeExportRoute (Parser.s "resume" </> Parser.s "export")
        , Parser.map ProjectsRoute (Parser.s "projects")
        ]


gotoUrl : Url -> Model -> Model
gotoUrl url model =
    case Parser.parse parser url of
        Just IndexRoute ->
            { model | page = Index }

        Just ResumeRoute ->
            { model | page = Resume }

        Just ResumeExportRoute ->
            { model | page = ResumeExport }

        Just ProjectsRoute ->
            { model | page = Projects }

        _ ->
            { model | page = NotFound }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
