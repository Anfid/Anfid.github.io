module Main exposing (main)

import Browser
import Browser.Events
import Browser.Navigation as Navigation
import Element exposing (Element, column, fill, px)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import ElementExt exposing (chapter, link, text)
import Html.Attributes
import Ports
import Process
import Projects
import Resume
import Simple.Animation as Animation
import Simple.Animation.Animated as Animated
import Simple.Animation.Property as AnimationProperty
import Styles exposing (Style)
import Task
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
    gotoUrl url <| Model key keys url Styles.Dark Index 0



-- MODEL


type alias Model =
    { key : Navigation.Key
    , dimensions : Dimensions
    , url : Url
    , style : Style
    , page : Page
    , styleAnimations : Int
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
    | Print
    | SwitchTheme
    | SwitchThemeDone Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, openInternalUrl model.key url )

                Browser.External href ->
                    ( model, Navigation.load href )

        UrlChanged url ->
            gotoUrl url model

        Resize w h ->
            ( { model | dimensions = { width = w, height = h } }, Cmd.none )

        Print ->
            ( model, Ports.printPage )

        SwitchTheme ->
            ( { model | styleAnimations = model.styleAnimations + 1 }
            , Process.sleep (toFloat styleSwitchDuration) |> Task.andThen (\_ -> Task.succeed <| model.styleAnimations + 1) |> Task.perform SwitchThemeDone
            )

        SwitchThemeDone count ->
            if count == model.styleAnimations then
                let
                    style =
                        if remainderBy 2 count == 0 then
                            model.style

                        else
                            Styles.flip model.style
                in
                ( { model | styleAnimations = 0, style = style }, Cmd.none )

            else
                ( model, Cmd.none )



-- VIEW


styleSwitchDuration : Int
styleSwitchDuration =
    500


view : Model -> Browser.Document Msg
view model =
    { title = "Mikhail Pogretskiy"
    , body =
        [ Element.layout
            [ Element.width fill ]
            (styleableView body model)
        ]
    }


body : Model -> Element Msg
body model =
    case model.page of
        Index ->
            column [ Background.color <| Styles.bgColor model.style, Element.width fill, Element.height fill, Element.spacing 30 ]
                [ bar model []
                , index model
                ]

        Resume ->
            column [ Background.color <| Styles.bgColor model.style, Element.width <| Element.minimum 570 fill ]
                [ bar model
                    [ Element.downloadAs (Styles.button model.style [])
                        { label =
                            Element.image (Styles.icon model.style [ Element.centerX, Element.centerY, Element.height <| px 20, Element.width <| px 20 ])
                                { src = "/assets/download.png", description = "Download" }
                        , filename = "Mikhail-Pogretskiy.pdf"
                        , url = "/assets/resume.pdf"
                        }
                    , Element.link (Styles.button model.style [])
                        { url = "/resume/export"
                        , label =
                            Element.image (Styles.icon model.style [ Element.centerX, Element.centerY, Element.height <| px 20, Element.width <| px 20 ])
                                { src = "/assets/print.png", description = "Print" }
                        }
                    ]
                , Element.el
                    [ Element.width <| Element.minimum 580 <| Element.maximum 840 fill, Element.centerX, Element.paddingXY 5 50 ]
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
                                [ Element.paddingEach { left = 25, right = 10, top = 5, bottom = 15 }, Font.size 25 ]
                                (Element.image (Styles.icon model.style [ Element.centerX, Element.centerY, Element.height <| px 32, Element.width <| px 32 ])
                                    { src = "/assets/print.png", description = "Print" }
                                )
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
                        Resume.contentView

        Projects ->
            column [ Background.color <| Styles.bgColor model.style, Element.width fill, Element.height fill, Element.spacing 30 ]
                [ bar model []
                , Element.map LinkClicked <|
                    Projects.view model.style
                ]

        NotFound ->
            Element.column [ Background.color <| Styles.bgColor model.style, Element.spacing 70, Element.centerX, Element.centerY ]
                [ Element.el (Styles.sansSerif model.style 100 [ Element.centerX ]) <| text "404"
                , Element.el (Styles.sansSerif model.style 50 [ Element.centerX ]) <| text "Not Found"
                , Element.link (Styles.button model.style [ Element.centerX ]) { label = Element.paragraph [] [ text "Let's go home?" ], url = "/" }
                ]


styleableView : (Model -> Element Msg) -> Model -> Element Msg
styleableView fView model =
    Element.el
        ([ Element.width fill, Element.height fill ] ++ styleStack fView (model.dimensions.width - 20) 20 model.styleAnimations { model | style = Styles.flip model.style })
    <|
        fView model


styleStack : (Model -> Element Msg) -> Int -> Int -> Int -> Model -> List (Element.Attribute Msg)
styleStack fView x y count model =
    if count > 0 then
        (Element.inFront <|
            Animated.ui
                { behindContent = Element.behindContent
                , htmlAttribute = Element.htmlAttribute
                , html = Element.html
                }
                Element.el
                (Animation.fromTo
                    { duration = styleSwitchDuration, options = [ Animation.easeInQuad ] }
                    [ AnimationProperty.property "clip-path"
                        ("circle(0px at "
                            ++ String.fromInt x
                            ++ "px "
                            ++ String.fromInt y
                            ++ "px)"
                        )
                    ]
                    [ AnimationProperty.property "clip-path"
                        ("circle("
                            ++ (String.fromInt <| (*) 2 <| max model.dimensions.height model.dimensions.width)
                            ++ "px at "
                            ++ String.fromInt x
                            ++ "px "
                            ++ String.fromInt y
                            ++ "px)"
                        )
                    ]
                )
                [ Element.width fill, Element.height fill ]
            <|
                fView model
        )
            :: styleStack fView x y (count - 1) { model | style = Styles.flip model.style }

    else
        []



-- elements


bar : Model -> List (Element Msg) -> Element Msg
bar model contextActions =
    let
        ( styleIcon, styleAttributes ) =
            case model.style of
                Styles.Dark ->
                    ( "/assets/sun.png", [ Element.htmlAttribute <| Html.Attributes.style "filter" "invert(90%)" ] )

                Styles.Light ->
                    ( "/assets/moon.png", [] )
    in
    Element.row (Styles.bar model.style [])
        [ Element.link (Styles.button model.style []) { url = "/", label = text "Home" }
        , Element.link (Styles.button model.style []) { url = "/projects", label = text "Projects" }
        , Element.link (Styles.button model.style []) { url = "/resume", label = text "Resume" }
        , Element.row [ Element.alignRight ] contextActions
        , Input.button (Styles.button model.style [])
            { onPress = Just SwitchTheme
            , label = Element.image ([ Element.centerX, Element.centerY, Element.height <| px 20, Element.width <| px 20 ] ++ styleAttributes) { src = styleIcon, description = "Dark/Light mode switch" }
            }
        ]


index : Model -> Element Msg
index model =
    column [ Element.width <| Element.maximum 900 fill, Element.padding 50, Element.spacing 50, Element.centerX ]
        [ Element.paragraph (Styles.paragraph model.style [])
            [ text <|
                "Hello, my name is Mikhail Pogretskiy. I am Rust software developer, and this page is created as a "
                    ++ "general overview of my software development background."
            ]
        , chapter "About me"
            model.style
            1
            [ Element.paragraph (Styles.paragraph model.style [])
                [ text <|
                    "My primary commercial Rust experience is related to blockchain, smart contracts and WASM. "
                        ++ "Other than that, I extend my knowledge in other areas by creating personal "
                        ++ "pet-projects with various levels of polish. They are usually quite limited "
                        ++ "due to lack of time and the amount of these projects."
                ]
            , Element.paragraph (Styles.paragraph model.style [])
                [ text <|
                    "I have experience in creating and designing multithreaded systems, and I enjoy writing portable, "
                        ++ "highly optimized code."
                ]
            ]
        , chapter "More"
            model.style
            1
            [ Element.paragraph (Styles.paragraph model.style [])
                [ text "You can find "
                , link model.style "my resume here" "/resume"
                , text ". If you need to download it, "
                , Element.downloadAs (Styles.link model.style []) { label = text "click here", filename = "Mikhail-Pogretskiy.pdf", url = "/assets/resume.pdf" }
                , text "."
                ]
            , Element.paragraph (Styles.paragraph model.style [])
                [ text "Also check out my "
                , link model.style "personal projects" "/projects"
                , text "."
                ]
            ]
        ]



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
    | ProjectsViewRoute String


parser : Parser (Route -> a) a
parser =
    Parser.oneOf
        [ Parser.map IndexRoute Parser.top
        , Parser.map ResumeRoute (Parser.s "resume")
        , Parser.map ResumeExportRoute (Parser.s "resume" </> Parser.s "export")
        , Parser.map ProjectsRoute (Parser.s "projects")
        , Parser.map ProjectsViewRoute
            (Parser.oneOf
                [ Parser.s "projects" </> Parser.string
                , Parser.s "projects" </> Parser.string </> Parser.s "index.html"
                ]
            )
        ]


openInternalUrl : Navigation.Key -> Url -> Cmd Msg
openInternalUrl key url =
    case Parser.parse parser url of
        Just (ProjectsViewRoute project) ->
            Navigation.load <| "/projects/" ++ project ++ "/index.html"

        _ ->
            Navigation.pushUrl key (Url.toString url)


gotoUrl : Url -> Model -> ( Model, Cmd Msg )
gotoUrl url model =
    case Parser.parse parser url of
        Just IndexRoute ->
            ( { model | page = Index }, Cmd.none )

        Just ResumeRoute ->
            ( { model | page = Resume }, Cmd.none )

        Just ResumeExportRoute ->
            ( { model | page = ResumeExport }, Cmd.none )

        Just ProjectsRoute ->
            ( { model | page = Projects }, Cmd.none )

        Just (ProjectsViewRoute project) ->
            ( model, Navigation.load <| "/projects/" ++ project ++ "/index.html" )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize Resize
