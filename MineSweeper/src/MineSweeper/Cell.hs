{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use tuple-section" #-}

module MineSweeper.Cell where

import MineSweeper.Types
    ( GameState(..)
    , CellState(..)
    , Cell(..)
    , Status(..)
    )
import qualified Data.Map as Map


openCell :: Int -> Int -> GameState -> GameState
openCell row col gState =
    case gameStatus gState of
        Playing -> gState { board = Map.adjust revealCell (row, col) (board gState) }
        _ -> gState


revealCell :: Cell -> Cell
revealCell cell = cell { state = Open }



toggleFlag:: Int -> Int -> GameState -> GameState
toggleFlag row col gState =
    case gameStatus gState of
        Playing -> gState { board = Map.adjust switchFlagState (row, col) (board gState) }
        _ -> gState

switchFlagState:: Cell -> Cell
switchFlagState cell = 
    case state cell of
        Closed -> cell { state = Flagged }
        Flagged -> cell { state = Closed }
        Open -> cell
