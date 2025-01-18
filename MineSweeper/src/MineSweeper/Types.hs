
module MineSweeper.Types
    ( GameState(..)
    , CellState(..)
    , Cell(..)
    , Status(..)
    ) where

import qualified Data.Map as Map

-- ゲームの状態
data GameState = GameState {
    board :: Map.Map (Int, Int) Cell,
    gameStatus :: Status
} deriving (Show)

-- セルの状態
data CellState = Open | Flagged | Closed deriving Show

-- セル
data Cell = Cell {
    hasMine :: Bool,
    state :: CellState,
    neighborMines :: Int
} deriving Show

-- ゲームの状態
data Status = Playing | GameOver | Won deriving Show