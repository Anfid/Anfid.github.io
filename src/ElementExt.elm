module ElementExt exposing (chapter, link, text)

import Element exposing (Element, fill)
import Html
import Styles exposing (Style)


text : String -> Element msg
text str =
    Element.html <| Html.text str


link : Style -> String -> String -> Element a
link style label url =
    Element.link (Styles.link style []) { label = Element.paragraph [] [ text label ], url = url }


chapter : String -> Style -> Int -> List (Element a) -> Element a
chapter heading style level content =
    Element.column [ Element.width fill, Element.height fill, Element.spacing 30 ] <|
        Element.paragraph (Styles.heading style level []) [ text heading ]
            :: content
