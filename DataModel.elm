module DataModel exposing (..)

import Html exposing (..)
import String exposing (join)
import List exposing (length)
import Array exposing (Array, get)


type alias Background msg =
    { template : Html msg
    }


type Pane
    = ShellPane { content : List BuildUp }
    | EditorPane { content : List BuildUp, filename : String }
    | HeaderPane { content : List BuildUp }


type Layout
    = TwoPanesStep
        { header : Pane
        , leftPane : Pane
        , rightPane : Pane
        }
    | SinglePaneStep
        { header : Pane
        , pane : Pane
        }
    | ImageStep
        { header : Pane
        , image : String
        }



{--Buildups are used to specify incrementally contents of one slide, in
    order to avoid having to repeat over and over the same content just
    to show small additions. Notice that you will be responsible for making
    sure that different parts of the slide have buildups in sync, by using
    the dummy "Reuse" buildup.
--}


type BuildUp
    = Reuse
    | Single String
    | Replace String
    | Append String
    | ReplaceLast String
    | ReplaceLastN Int String


foldBuildup : BuildUp -> List String -> List String



{--Given a list of buildups, it calculates the string corresponding to folding
    each buildup one after the other.
 --}


foldBuildup next acc =
    case next of
        Reuse ->
            acc

        Single a ->
            [ a ]

        Replace a ->
            [ a ]

        Append a ->
            acc ++ [ a ]

        ReplaceLast a ->
            (List.take ((List.length acc) - 1) acc) ++ [ a ]

        ReplaceLastN n a ->
            (List.take ((List.length acc) - n) acc) ++ [ a ]


maxSlideBuildUp : Int -> Array Layout -> Int
maxSlideBuildUp i slides =
    maxBuildUp (get i slides) - 1


maxBuildUp : Maybe Layout -> Int
maxBuildUp layout =
    case layout of
        Just (TwoPanesStep a) ->
            max (maxPaneBuildUp a.leftPane) (maxPaneBuildUp a.rightPane)

        Just (SinglePaneStep a) ->
            maxPaneBuildUp a.pane

        Just (ImageStep a) ->
            1

        Nothing ->
            1


maxPaneBuildUp : Pane -> Int
maxPaneBuildUp pane =
    case pane of
        ShellPane pane ->
            length pane.content

        EditorPane pane ->
            length pane.content

        HeaderPane pane ->
            length pane.content


evaluateBuildUp : Int -> List BuildUp -> String
evaluateBuildUp n allBuildups =
    let
        buildups =
            List.take (n + 1) allBuildups
    in
        join "" (List.foldl foldBuildup [] buildups)
