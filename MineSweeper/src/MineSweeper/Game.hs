{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use tuple-section" #-}
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
import System.Random
import Data.Time.Clock

initialGameState :: IO (IORef GameState)
initialGameState = do
    seed <- timeToInt
    newIORef $ GameState {
        board = createBombs 20 seed,
        gameStatus = Playing
    }

handleClick :: Int -> Int -> GameState -> GameState
handleClick row col state =
    case gameStatus state of
        Playing -> state { board = Map.adjust revealCell (row, col) (board state) }
        _ -> state

revealCell :: Cell -> Cell
revealCell cell = cell { state = Open }

pack :: String -> Text
pack = Data.Text.Lazy.pack

timeToInt :: IO Int
timeToInt = do
    floor . utctDayTime <$> getCurrentTime


neighbors :: (Int, Int) -> [(Int, Int)]
neighbors (r, c) = [(r + dr, c + dc) | dr <- [-1..1], dc <- [-1..1], not (dr == 0 && dc == 0)]

countNeighborMines :: [(Int, Int)] -> (Int, Int) -> Int
countNeighborMines bombs (r, c) = length $ filter (`elem` bombs) (neighbors (r, c))

createCellCoords:: [(Int, Int)]
createCellCoords = [(r, c) | r <- [0..7], c <- [0..7]]

createBombsCoord :: Int -> Int -> [(Int, Int)]
createBombsCoord count seed =
    let cells = createCellCoords
        bombs = take count $ randomRs (0, 63) (mkStdGen seed)
    in map (cells !!) bombs


createBombs :: Int -> Int ->  Map.Map (Int, Int) Cell
createBombs count seed =
    let cells = createCellCoords
        bombCoords = createBombsCoord count seed;
        boards = Map.fromList $ map (\x -> (x, Cell {hasMine = x `elem` bombCoords, state = Closed, neighborMines = countNeighborMines bombCoords x})) cells
    in boards