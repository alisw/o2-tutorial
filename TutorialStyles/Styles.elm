module TutorialStyles.Styles exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


headerStyle : Attribute msg
headerStyle =
    style
        [ ( "color", "rgb(67, 67, 67" )
        , ( "height", "200px" )
        , ( "max-width", "80%" )
        , ( "line-height", "25.600000381469727px" )
        , ( "font-size", "16px" )
        , --    ("font-family", "OpenSansBold, 'Helvetica Neue', Helvetica, Arial, sans-serif"),
          ( "margin-bottom", "16px" )
        , ( "padding-left", "60px" )
        , ( "padding-right", "60px" )
        ]


bodyStyle : Attribute msg
bodyStyle =
    style
        [ ( "height", "700px" )
        , ( "border-top-color", "rgb(38, 89, 127)" )
        , ( "border-top-style", "solid" )
        , ( "border-top-width", "1px" )
        , ( "background-color", "rgb(59, 132, 192)" )
        ]


innerStyle : Attribute msg
innerStyle =
    style
        [ ( "color", "rgb(67, 67, 67)" )
        , ( "display", "block" )
        , ( "font-family", "OpenSansRegular, 'Helvetica Neue', Helvetica, Arial, sans-serif" )
        , ( "font-size", "10px" )
        , ( "height", "600" )
        , ( "margin-bottom", "0px" )
        , ( "margin-left", "0px" )
        , ( "margin-right", "0px" )
        , ( "margin-top", "0px" )
        , ( "padding-bottom", "0px" )
        , ( "padding-left", "60px" )
        , ( "padding-right", "60px" )
        , ( "padding-top", "0px" )
        ]


shellTabStyle : Attribute msg
shellTabStyle =
    style
        [ ( "background-color", "rgb(239, 237, 238)" )
        , ( "background-image", "-webkit-linear-gradient(top, rgb(239, 237, 238), rgb(193, 193, 193))" )
        , ( "border-bottom-color", "rgb(67, 67, 67)" )
        , ( "border-bottom-left-radius", "0px" )
        , ( "border-bottom-right-radius", "0px" )
        , ( "border-bottom-style", "none" )
        , ( "border-bottom-width", "0px" )
        , ( "border-image-outset", "0px" )
        , ( "border-image-repeat", "stretch" )
        , ( "border-image-slice", "100%" )
        , ( "border-image-source", "none" )
        , ( "border-image-width", "1" )
        , ( "border-left-color", "rgb(98, 135, 164)" )
        , ( "border-left-style", "solid" )
        , ( "border-left-width", "1px" )
        , ( "border-right-color", "rgb(98, 135, 164)" )
        , ( "border-right-style", "solid" )
        , ( "border-right-width", "1px" )
        , ( "border-top-color", "rgb(98, 135, 164)" )
        , ( "border-top-left-radius", "3px" )
        , ( "border-top-right-radius", "3px" )
        , ( "border-top-style", "solid" )
        , ( "border-top-width", "1px" )
        , ( "color", "rgb(67, 67, 67)" )
        , ( "display", "block" )
        , ( "font-family", "OpenSansRegular, 'Helvetica Neue', Helvetica, Arial, sans-serif" )
        , ( "font-size", "10px" )
        , ( "height", "30px" )
        , ( "margin-bottom", "0px" )
        , ( "margin-left", "0px" )
        , ( "margin-right", "0px" )
        , ( "margin-top", "20px" )
        , ( "padding-bottom", "0px" )
        , ( "padding-left", "0px" )
        , ( "padding-right", "0px" )
        , ( "padding-top", "0px" )
        , ( "position", "relative" )
        , ( "zoom", "1" )
        , ( "text-align", "center" )
        ]


shellStyle : Attribute msg
shellStyle =
    style
        [ ( "-webkit-background-clip", "border-box" )
        , ( "-webkit-background-origin", "padding-box" )
        , ( "-webkit-background-size", "auto" )
        , ( "background-attachment", "scroll" )
        , ( "background-clip", "border-box" )
        , ( "background-color", "rgb(66, 66, 66)" )
        , ( "background-image", "none" )
        , ( "background-origin", "padding-box" )
        , ( "background-size", "auto" )
        , ( "color", "rgb(255, 255, 255)" )
        , ( "display", "block" )
        , ( "font-family", "Monaco, Courier, font-monospace" )
        , ( "font-size", "14px" )
        , ( "font-style", "normal" )
        , ( "font-variant", "normal" )
        , ( "font-weight", "normal" )
        , ( "height", "600px" )
        , ( "line-height", "23px" )
        , ( "margin-bottom", "0px" )
        , ( "margin-left", "0px" )
        , ( "margin-right", "0px" )
        , ( "margin-top", "0px" )
        , ( "overflow-y", "auto" )
        , ( "padding-bottom", "5px" )
        , ( "padding-left", "5px" )
        , ( "padding-right", "5px" )
        , ( "padding-top", "5px" )
        ]


editorStyle : Attribute msg
editorStyle =
    style
        [ ( "-webkit-background-clip", "border-box" )
        , ( "-webkit-background-origin", "padding-box" )
        , ( "-webkit-background-size", "auto" )
        , ( "background-attachment", "scroll" )
        , ( "background-clip", "border-box" )
        , ( "background-color", "#f0f0f0" )
        , ( "background-image", "none" )
        , ( "background-origin", "padding-box" )
        , ( "background-size", "auto" )
        , ( "color", "rgb(4, 4, 4)" )
        , ( "display", "block" )
        , ( "font-family", "Monaco, Courier, font-monospace" )
        , ( "font-size", "14px" )
        , ( "font-style", "normal" )
        , ( "font-variant", "normal" )
        , ( "font-weight", "normal" )
        , ( "height", "600px" )
        , ( "line-height", "23px" )
        , ( "margin-bottom", "0px" )
        , ( "margin-left", "0px" )
        , ( "margin-right", "0px" )
        , ( "margin-top", "0px" )
        , ( "overflow-y", "auto" )
        , ( "padding-bottom", "5px" )
        , ( "padding-left", "5px" )
        , ( "padding-right", "5px" )
        , ( "padding-top", "5px" )
        ]


titleStyle : Attribute msg
titleStyle =
    style
        [ ( "color", "rgb(0, 0, 0)" )
        , ( "display", "inline" )
        , ( "font-family", "'Helvetica Neue', Helvetica, Arial, sans-serif" )
        , ( "font-size", "13px" )
        , ( "font-style", "normal" )
        , ( "font-variant", "normal" )
        , ( "font-weight", "normal" )
        , ( "height", "auto" )
        , ( "line-height", "30px" )
        , ( "position", "relative" )
        , ( "text-align", "center" )
        , ( "text-shadow", "rgb(255, 255, 255) 0px 1px 0px" )
        ]


stepperStyle : Attribute msg
stepperStyle =
    style
        [ ( "color", "rgb(67, 67, 67)" )
        , ( "display", "block" )
        , ( "font-family", "OpenSansRegular, 'Helvetica Neue', Helvetica, Arial, sans-serif" )
        , ( "font-size", "10px" )
        , ( "height", "24px" )
        , ( "list-style-image", "none" )
        , ( "list-style-position", "outside" )
        , ( "list-style-type", "none" )
        , ( "margin-bottom", "0px" )
        , ( "margin-left", "0px" )
        , ( "margin-right", "0px" )
        , ( "margin-top", "0px" )
        , ( "padding-bottom", "0px" )
        , ( "padding-left", "0px" )
        , ( "padding-right", "0px" )
        , ( "padding-top", "7px" )
        ]


stepStyle : Attribute msg
stepStyle =
    style
        [ ( "-webkit-background-clip", "border-box" )
        , ( "-webkit-background-origin", "padding-box" )
        , ( "-webkit-background-size", "auto" )
        , ( "background-attachment", "scroll" )
        , ( "background-clip", "border-box" )
        , ( "background-color", "rgba(0, 0, 0, 0)" )
          --        , ( "background-image", "url(https://d13jv82ekraqyq.cloudfront.net/assets/bg-progress-bar-filled-77f1716a0eefdfeceb005135e8a13705.png)" )
        , ( "background-origin", "padding-box" )
        , ( "background-size", "auto" )
        , ( "color", "rgb(67, 67, 67)" )
        , ( "display", "list-item" )
        , ( "float", "left" )
        , ( "font-family", "OpenSansRegular, 'Helvetica Neue', Helvetica, Arial, sans-serif" )
        , ( "font-size", "10px" )
        , ( "height", "24px" )
        , ( "list-style-image", "none" )
        , ( "list-style-position", "outside" )
        , ( "list-style-type", "none" )
        , ( "margin-bottom", "0px" )
        , ( "margin-left", "0px" )
        , ( "margin-right", "0px" )
        , ( "margin-top", "0px" )
        , ( "padding-bottom", "0px" )
        , ( "padding-left", "0px" )
        , ( "padding-right", "0px" )
        , ( "padding-top", "0px" )
        , ( "position", "relative" )
        , ( "text-align", "left" )
          --       , ( "width", "36.09375px" )
        ]


incompleteStep : Attribute msg
incompleteStep =
    style
        [ ( "-webkit-background-clip", "border-box" )
        , ( "-webkit-background-origin", "padding-box" )
        , ( "-webkit-background-size", "auto" )
        , ( "background-attachment", "scroll" )
        , ( "background-clip", "border-box" )
        , ( "background-color", "rgba(0, 0, 0, 0)" )
          --        , ( "background-image", "url(https://d13jv82ekraqyq.cloudfront.net/assets/bg-progress-link-00feefaa8cd9a07088d1118deeb4b27b.png)" )
        , ( "background-origin", "padding-box" )
        , ( "background-size", "auto" )
        , ( "color", "#5c5c5c" )
        , ( "cursor", "auto" )
        , ( "display", "block" )
        , ( "float", "right" )
        , ( "font-family", "OpenSansRegular, 'Helvetica Neue', Helvetica, Arial, sans-serif" )
        , ( "font-size", "10px" )
        , ( "height", "24px" )
        , ( "list-style-image", "none" )
        , ( "list-style-position", "outside" )
        , ( "list-style-type", "none" )
        , ( "text-align", "left" )
        , ( "text-decoration", "none" )
          --       , ( "width", "18px" )
        ]


completeStep : Attribute msg
completeStep =
    style
        [ ( "-webkit-background-clip", "border-box" )
        , ( "-webkit-background-origin", "padding-box" )
        , ( "-webkit-background-size", "auto" )
        , ( "background-attachment", "scroll" )
        , ( "background-clip", "border-box" )
        , ( "background-color", "rgba(0, 0, 0, 0)" )
          --        , ( "background-image", "url(https://d13jv82ekraqyq.cloudfront.net/assets/bg-progress-link-filled-550b82cbc81eb5f56ff099f1a7b28b86.png)" )
        , ( "background-origin", "padding-box" )
        , ( "background-size", "auto" )
        , ( "color", "#1eb29b" )
        , ( "cursor", "auto" )
        , ( "display", "block" )
        , ( "float", "right" )
        , ( "font-family", "OpenSansRegular, 'Helvetica Neue', Helvetica, Arial, sans-serif" )
        , ( "font-size", "10px" )
        , ( "height", "24px" )
        , ( "list-style-image", "none" )
        , ( "list-style-position", "outside" )
        , ( "list-style-type", "none" )
        , ( "text-align", "left" )
        , ( "text-decoration", "none" )
          --        , ( "width", "18px" )
        ]


topBarStyle =
    style
        [ ( "-webkit-backface-visibility", "hidden" )
        , ( "-webkit-background-clip", "border-box" )
        , ( "-webkit-background-origin", "padding-box" )
        , ( "-webkit-background-size", "auto" )
        , ( "-webkit-transition-delay", "0s" )
        , ( "-webkit-transition-duration", "0.7s" )
        , ( "-webkit-transition-property", "top" )
        , ( "-webkit-transition-timing-function", "ease-in-out" )
        , ( "background-attachment", "scroll" )
        , ( "background-clip", "border-box" )
        , ( "background-color", "rgb(237, 237, 237)" )
        , ( "background-image", "none" )
        , ( "background-origin", "padding-box" )
        , ( "background-size", "auto" )
        , ( "border-bottom-color", "rgb(211, 211, 211)" )
        , ( "border-bottom-style", "solid" )
        , ( "border-bottom-width", "1px" )
        , ( "color", "rgb(67, 67, 67)" )
        , ( "display", "block" )
        , --    ("height", "35px"),
          --    ("margin-bottom", "0px"),
          --    ("margin-left", "10px"),
          --    ("margin-right", "0px"),
          --    ("margin-top", "10px"),
          ( "padding-bottom", "10px" )
        , ( "padding-left", "10px" )
        , --    ("padding-right", "0px"),
          ( "padding-top", "10px" )
        , ( "transition-delay", "0s" )
        , ( "transition-duration", "0.7s" )
        , ( "transition-property", "top" )
        , ( "transition-timing-function", "ease-in-out" )
        , ( "z-index", "1" )
        ]


descriptionStyle =
    style
        [ ( "padding-top", "20px" )
        ]
