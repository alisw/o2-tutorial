module O2Tutorial exposing (..)

import Array exposing (..)
import Html exposing (..)
import Markdown
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import RouteHash
import TutorialStyles.Styles exposing (..)
import DataModel exposing (..)
import Story exposing (..)


render : Int -> Pane -> List (Html Msg)
render buildup pane =
    let
        eval =
            evaluateBuildUp buildup
    in
        case pane of
            ShellPane a ->
                [ div [ shellTabStyle ] [ span [ titleStyle ] [ text "Welcome to Alice O2" ] ]
                , div [ shellStyle ] [ Markdown.toHtml [] ("```\n" ++ eval a.content ++ "```") ]
                ]

            EditorPane a ->
                [ div [ shellTabStyle ] [ span [ titleStyle ] [ text a.filename ] ]
                , div [ editorStyle ] [ pre [] [ code [ class "lang-cpp" ] [ text (String.trim (eval a.content)) ] ] ]
                ]

            HeaderPane a ->
                [ Markdown.toHtml [] (eval a.content)
                ]


applyLayout : Int -> Layout -> Html Msg
applyLayout buildup layout =
    case layout of
        SinglePaneStep step ->
            div []
                [ div [ headerStyle ] (render buildup step.header)
                , div [ bodyStyle ]
                    [ div [ class "pure-g" ]
                        [ div [ class "pure-u-1-24" ] []
                        , div [ class "pure-u-22-24" ]
                            (render buildup step.pane)
                        , div [ class "pure-u-1-24" ] []
                        ]
                    ]
                ]

        TwoPanesStep step ->
            div []
                [ div [ headerStyle ] (render buildup step.header)
                , div [ bodyStyle ]
                    [ div [ class "pure-g", innerStyle ]
                        [ div [ class "pure-u-1-2" ]
                            [ div [ style [ ( "padding-right", "15px" ) ] ]
                                (render buildup step.leftPane)
                            ]
                        , div [ class "pure-u-1-2" ]
                            [ div [ style [ ( "padding-left", "15px" ) ] ]
                                (render buildup step.rightPane)
                            ]
                        ]
                    ]
                , div [] []
                ]

        ImageStep step ->
            div []
                [ div [ headerStyle ] (render buildup step.header)
                , div [ bodyStyle ]
                    [ div [ class "pure-g", style [ ( "text-align", "center" ) ] ]
                        [ div [ innerStyle, class "pure-u-1", style [ ( "text-align", "center" ) ] ]
                            [ img [ src step.image ] [ text "A test image" ]
                            ]
                        ]
                    ]
                , div [] []
                ]


type alias Model =
    { currentStep : Int
    , currentBuildUp : Int
    , slides : Array Layout
    }


model : Model
model =
    { currentStep = 0
    , currentBuildUp = 0
    , slides = Array.fromList story
    }



-- messages : Signal.Mailbox Msg
-- messages =
--     Signal.mailbox NoOp


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


moveToPage : Int -> Int -> Model -> Model
moveToPage page buildup model =
    { model | currentStep = page, currentBuildUp = buildup }



-- Hash updates simply are used to move from one step to the other.


delta2update : Model -> Model -> Maybe RouteHash.HashUpdate
delta2update old new =
    let
        same =
            old.currentStep
                == new.currentStep
                && old.currentBuildUp
                == new.currentBuildUp
    in
        case same of
            False ->
                Just (RouteHash.set [ toString new.currentStep, toString new.currentBuildUp ])

            True ->
                Maybe.Nothing


location2action : List String -> List Msg
location2action uriParts =
    case uriParts of
        page :: buildup :: rest ->
            case ( String.toInt page, String.toInt buildup ) of
                ( Ok i, Ok j ) ->
                    [ MoveToPage i j ]

                _ ->
                    [ NoOp ]

        page :: rest ->
            case (String.toInt page) of
                Ok i ->
                    [ MoveToPage i 0 ]

                _ ->
                    [ NoOp ]

        [] ->
            [ NoOp ]



-- port routeTasks : Signal (Task () ())
-- port routeTasks =
--     RouteHash.start
--         { prefix = RouteHash.defaultPrefix
--         , address = messages.address
--         , models = app.model
--         , delta2update = delta2update
--         , location2action = location2action
--         }


currentBackground : Model -> Html Msg
currentBackground model =
    let
        maybeBackground =
            get model.currentStep model.slides
    in
        case maybeBackground of
            Just slide ->
                div [] [ applyLayout model.currentBuildUp slide ]

            Maybe.Nothing ->
                div [] [ text "Error" ]


stepKind : Int -> Model -> Attribute msg
stepKind n model =
    if n == 0 then
        completeStep
    else if n > model.currentStep then
        incompleteStep
    else
        completeStep


stepper : Model -> Html msg
stepper model =
    let
        numberOfSlides =
            Array.length (model.slides)

        navigationButton =
            (\n -> li [ stepStyle ] [ a [ href ("#" ++ (toString n)), stepKind n model ] [ text (toString n) ] ])
    in
        ol [ stepperStyle ] (List.map navigationButton (List.range 0 (numberOfSlides - 1)))


title : Model -> Html Msg
title model =
    div [ style [ ( "margin-top", "6px" ) ] ]
        [ span [ onClick (Arrows { x = -1, y = 0 }), style [ ( "margin-right", "10px" ), ( "cursor", "pointer" ) ] ] [ text (String.fromChar '◀') ]
        , text ("Section: " ++ toString model.currentStep ++ " / Step: " ++ toString model.currentBuildUp)
        , span [ onClick (Arrows { x = 1, y = 0 }), style [ ( "margin-left", "10px" ), ( "cursor", "pointer" ) ] ] [ text (String.fromChar '▶') ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class "pure-g", topBarStyle ]
            [ div [ class "pure-u-1-2" ] [ title model ]
            , div [ class "pure-u-1-2" ] [ stepper model ]
            ]
        , div [ descriptionStyle ] [ currentBackground model ]
        ]


type Msg
    = NoOp
    | MoveToPage Int Int
    | Arrows { x : Int, y : Int }
    | Enter Bool


handleArrows : Model -> { x : Int, y : Int } -> Model
handleArrows model a =
    let
        slides =
            model.slides

        previousPageMaxBuildUp =
            maxSlideBuildUp (model.currentStep - 1) slides

        currentPageMaxBuildUp =
            maxSlideBuildUp model.currentStep slides

        nextPageMaxBuildUp =
            maxSlideBuildUp (model.currentStep + 1) slides

        tentativeBuildUp =
            model.currentBuildUp + a.x

        ( nextPage, nextBuildUp ) =
            if tentativeBuildUp < 0 then
                ( model.currentStep - 1, previousPageMaxBuildUp )
            else if tentativeBuildUp > currentPageMaxBuildUp then
                ( model.currentStep + 1, 0 )
            else
                ( model.currentStep, tentativeBuildUp )

        lastPage =
            (Array.length model.slides) - 1

        page =
            if nextPage < 0 then
                0
            else if nextPage >= lastPage then
                lastPage
            else
                nextPage

        buildup =
            if nextBuildUp < 0 then
                0
            else if nextBuildUp > 10 then
                10
            else
                nextBuildUp
    in
        moveToPage page buildup model


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        MoveToPage page buildup ->
            ( moveToPage page buildup model, Cmd.none )

        Arrows a ->
            ( handleArrows model a, Cmd.none )

        Enter True ->
            ( handleArrows model { x = 1, y = 0 }, Cmd.none )

        Enter False ->
            ( handleArrows model { x = 1, y = 0 }, Cmd.none )



-- port currentPage : Int -> Cmd msg
-- port currentPage =
--     Signal.map (\n -> 1) messages.signal
