module MineSweeper.Game where

import MineSweeper.Types
    ( GameState(..)
    , CellState(..)
    , Cell(..)
    , Status(..)
    )
import Data.IORef
import qualified Data.Map as Map
import Data.Text.Lazy (Text, pack)

initialGameState :: IO (IORef GameState)
initialGameState = newIORef $ GameState {
    board = Map.empty,
    gameStatus = Playing
}

handleClick :: Int -> Int -> GameState -> GameState
handleClick row col state = 
    case gameStatus state of
        Playing -> state { board = Map.adjust revealCell (row, col) (board state) }
        _ -> state

revealCell :: Cell -> Cell
revealCell cell = cell { state = Closed }

pack :: String -> Text
pack = Data.Text.Lazy.pack