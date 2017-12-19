module O2Tutorial exposing (..)

import Array exposing (..)
import DataModel exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Keyboard exposing (..)
import Keyboard.Extra exposing (..)
import Markdown
import RouteHash
import Story exposing (..)
import TutorialStyles.Styles exposing (..)
import RouteUrl exposing (RouteUrlProgram)
import RouteUrl.Builder as Builder exposing (Builder)
import Navigation exposing (Location)


stylesheet =
    let
        tag =
            "link"

        attrs =
            [ attribute "rel" "stylesheet"
            , attribute "property" "stylesheet"
            , attribute "href" "pure-min.css"
            , attribute "integrity" "sha384-nn4HPE8lTHyVtfCBi5yW9d20FjT8BJwUXyWZT9InLYax14RDjBj46LmSztkmNP9w"
            ]

        children =
            []
    in
        node tag attrs children


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


type alias SectionIndex =
    Int


type alias BuildUpIndex =
    Int


type alias SlideIndexEntry =
    { section : SectionIndex
    , buildup : BuildUpIndex
    }


type alias Model =
    { pressedKeys : List Key
    , currentPage : Int
    , currentSection : SectionIndex
    , currentBuildUp : BuildUpIndex
    , title : String
    , slides : Array Layout
    , slidesIndex : Array SlideIndexEntry
    , pageError : Maybe String
    }


computeBuildupList : Layout -> List Int
computeBuildupList layout =
    List.range 0 ((maxBuildUp (Just layout)) - 1)


computeSlideIndex : List Layout -> Array SlideIndexEntry
computeSlideIndex slides =
    let
        enumeratedSlides =
            List.indexedMap (,) slides

        nestedIndex =
            List.map (\( x, y ) -> ( x, List.indexedMap (,) (computeBuildupList y) )) enumeratedSlides
                |> List.map (\( x, y ) -> List.map (\( w, z ) -> ( x, w )) y)
    in
        List.concatMap (\x -> x) nestedIndex
            |> List.map (\( x, y ) -> { section = x, buildup = y })
            |> Array.fromList


model : Model
model =
    { pressedKeys = []
    , currentPage = 0
    , currentSection = 0
    , currentBuildUp = 0
    , title = story.title
    , slides = Array.fromList story.layouts
    , slidesIndex = computeSlideIndex story.layouts
    , pageError = Maybe.Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


main : RouteUrlProgram Never Model Msg
main =
    RouteUrl.program
        { delta2url = delta2update
        , location2messages = location2messages
        , init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


moveToPage : SectionIndex -> BuildUpIndex -> Model -> Model
moveToPage section buildup model =
    { model | currentSection = section, currentBuildUp = buildup }



-- Hash updates simply are used to move from one step to the other.


builderForStateFrom : Model -> Builder
builderForStateFrom model =
    Builder.builder
        |> Builder.modifyEntry
        |> Builder.replacePath [ toString model.currentSection, toString model.currentBuildUp ]


delta2update : Model -> Model -> Maybe RouteUrl.UrlChange
delta2update old new =
    let
        same =
            (old.currentSection == new.currentSection)
                && (old.currentBuildUp == new.currentBuildUp)

        builder =
            builderForStateFrom new
    in
        case same of
            False ->
                Just (Builder.toHashChange builder)

            True ->
                Maybe.Nothing



-- Parses the Location and creates adeguate Msg
-- when it changes.


location2messages : Location -> List Msg
location2messages location =
    let
        builder =
            Builder.fromHash location.hash
    in
        case Builder.path builder of
            page :: buildup :: rest ->
                case ( String.toInt page, String.toInt buildup ) of
                    ( Ok i, Ok j ) ->
                        [ MoveToPage i j ]

                    _ ->
                        [ UnknownPage (String.join "/" (Builder.path builder)) ]

            page :: rest ->
                case (String.toInt page) of
                    Ok i ->
                        [ MoveToPage i 0 ]

                    _ ->
                        [ UnknownPage (String.join "/" (Builder.path builder)) ]

            _ ->
                [ MoveToPage 0 0 ]


currentBackground : Model -> Html Msg
currentBackground model =
    let
        maybeBackground =
            get model.currentSection model.slides
    in
        case maybeBackground of
            Just slide ->
                div [] [ applyLayout model.currentBuildUp slide ]

            Maybe.Nothing ->
                div [] [ text "Error" ]


stepKind : Int -> Int -> Model -> Attribute msg
stepKind currentSection currentBuildUp model =
    if currentSection > model.currentSection then
        incompleteStep
    else if currentSection == model.currentSection && currentBuildUp > model.currentBuildUp then
        incompleteStep
    else
        completeStep


stepper : Model -> Html msg
stepper model =
    let
        numberOfSlides =
            Array.length (model.slides)

        navigationLink model =
            \slide ->
                Builder.builder
                    |> Builder.modifyEntry
                    |> Builder.replacePath
                        [ toString model.currentSection
                        , toString model.currentBuildUp
                        ]
                    |> Builder.toUrlChange

        navigationButton indexEntry =
            let
                { section, buildup } =
                    indexEntry

                newHash =
                    (toString section) ++ "/" ++ (toString 0)

                stepBullet =
                    case buildup of
                        0 ->
                            "⬤"

                        _ ->
                            "●"
            in
                li [ stepStyle ]
                    [ a [ href ("#!" ++ newHash), stepKind section buildup model ]
                        [ text stepBullet ]
                    ]
    in
        ol [ stepperStyle ] (Array.toList (Array.map navigationButton model.slidesIndex))


currentSectionTitle : Model -> String
currentSectionTitle model =
    let
        currentSlide =
            get model.currentSection model.slides
    in
        case currentSlide of
            Just slide ->
                case slide of
                    ImageStep a ->
                        a.title

                    TwoPanesStep a ->
                        a.title

                    SinglePaneStep a ->
                        a.title

            Maybe.Nothing ->
                ""


arrowNavigator model =
    [ span [ onClick (Arrows { x = -1, y = 0 }), style [ ( "margin-right", "10px" ), ( "cursor", "pointer" ) ] ] [ text (String.fromChar '◀') ]
    , text ("Section: " ++ toString model.currentSection ++ " / Step: " ++ toString model.currentBuildUp)
    , span [ onClick (Arrows { x = 1, y = 0 }), style [ ( "margin-left", "10px" ), ( "cursor", "pointer" ) ] ] [ text (String.fromChar '▶') ]
    ]


title : Model -> Html Msg
title model =
    let
        titleStyle =
            [ ( "font-size", "120%" )
            , ( "font-weight", "bold" )
            ]
    in
        div [ style [ ( "margin-top", "6px" ) ] ]
            [ span [ style titleStyle ] [ text (model.title ++ " > " ++ (currentSectionTitle model)) ]
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map KeyMsg Keyboard.Extra.subscriptions
        ]


errorDialog : Model -> List (Html Msg)
errorDialog model =
    case model.pageError of
        Maybe.Nothing ->
            []

        Just error ->
            [ pre [] [ text error ] ]


view : Model -> Html Msg
view model =
    div []
        ([ stylesheet ]
            ++ (errorDialog model)
            ++ [ div [ class "pure-g", topBarStyle ]
                    [ div [ class "pure-u-1-2" ] [ title model ]
                    , div [ class "pure-u-1-3" ] [ stepper model ]
                    , div [ class "pure-u-1-6" ] (arrowNavigator model)
                    ]
               , div [ descriptionStyle ] [ currentBackground model ]
               ]
        )


type Msg
    = NoOp
    | UnknownPage String
    | MoveToPage Int Int
    | KeyMsg Keyboard.Extra.Msg
    | Arrows { x : Int, y : Int }


handleKeys : Model -> Keyboard.Extra.Msg -> Model
handleKeys model msg =
    let
        pressedKeys =
            Keyboard.Extra.update msg []

        arrows =
            Keyboard.Extra.arrows pressedKeys
    in
        handleArrows model arrows


handleArrows : Model -> { x : Int, y : Int } -> Model
handleArrows model a =
    let
        nextPage =
            Basics.min (Basics.max 0 (model.currentPage + a.x)) (Array.length model.slidesIndex - 1)

        index =
            get nextPage model.slidesIndex
    in
        case index of
            Just { section, buildup } ->
                { model
                    | currentPage = nextPage
                    , currentSection = section
                    , currentBuildUp = buildup
                }

            Maybe.Nothing ->
                { model
                    | pageError = Just ("Page not found" ++ (toString nextPage))
                }


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        NoOp ->
            ( model, Cmd.none )

        MoveToPage page buildup ->
            ( moveToPage page buildup model, Cmd.none )

        KeyMsg a ->
            ( handleKeys model a, Cmd.none )

        Arrows a ->
            ( handleArrows model a |> (\m -> (moveToPage m.currentSection m.currentBuildUp m)), Cmd.none )

        UnknownPage a ->
            ( { model | pageError = Just a }, Cmd.none )
