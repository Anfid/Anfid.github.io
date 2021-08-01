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
            Element.paragraph (Styles.paragraph model.style []) [ text "TODO" ]

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
    column [ Element.width fill, Element.paddingXY 50 0, Element.spacing 50 ]
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
            [ Element.paragraph (Styles.paragraph model.style []) [ text "TODO" ]
            ]
        ]


chapter : String -> Style -> Int -> List (Element Msg) -> Element Msg
chapter heading style level content =
    Element.column [ Element.spacing 15 ] <|
        [ Element.paragraph (Styles.heading style level []) <|
            [ text heading ]
        ]
            ++ content


link : Style -> String -> String -> Element Msg
link style label url =
    Element.link (Styles.link style) { label = Element.paragraph [] [ text label ], url = url }



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
