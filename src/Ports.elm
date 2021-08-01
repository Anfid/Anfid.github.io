port module Ports exposing (printPage)


printPage : Cmd msg
printPage =
    sendMessage "print"


port sendMessage : String -> Cmd msg
