{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE InstanceSigs #-}

module MineSweeper.Types
    ( GameState(..)
    , CellState(..)
    , Cell(..)
    , Status(..)
    , ClickResult(..)
    , ClickData(..)
    ) where

import qualified Data.Map as Map

import qualified Data.Aeson as A  
import Data.Aeson ((.=))
import Data.String (fromString)
import qualified Data.Text as T
import GHC.Generics


-- ClickResultのToJSONインスタンス


-- GameStateのToJSONインスタンス
instance A.ToJSON GameState where
    toJSON :: GameState -> A.Value
    toJSON gState = A.object [
        fromString "board" .= board gState,
        fromString "status" .= gameStatus gState
        ]

-- CellのToJSONインスタンス
instance A.ToJSON Cell where
    toJSON (Cell hMine cellState nMines) = A.object [
        fromString "hasMine" .= hMine,
        fromString "state" .= cellState,
        fromString "neighborMines" .= nMines
        ]

-- StatusのToJSONインスタンス
instance A.ToJSON Status where
    toJSON Playing = A.String (T.pack "Playing")
    toJSON Won = A.String (T.pack "Won")
    toJSON GameOver = A.String (T.pack "GameOver")

-- CellStateのToJSONインスタンス
instance A.ToJSON CellState where
    toJSON Open = A.String (T.pack "Open")
    toJSON Flagged = A.String (T.pack "Flagged")
    toJSON Closed = A.String (T.pack "Closed")
    
instance A.ToJSON ClickResult where
    toJSON (ClickResult status cell) = A.object [
        fromString "status" .= status,
        fromString "cell" .= cell
        ]

-- ゲームの状態
data GameState = GameState {
    board :: Map.Map (Int, Int) Cell,
    gameStatus :: Status
} deriving (Show)

-- セルの状態
data CellState = Open | Flagged | Closed deriving Show

-- クリック時のリザルト
data ClickResult = ClickResult Status Cell
    deriving (Show)

-- セル
data Cell = Cell {
    hasMine :: Bool,
    state :: CellState,
    neighborMines :: Int
} deriving Show

-- ゲームの状態
data Status = Playing | GameOver | Won deriving Show


data ClickData = ClickData 
    { cellRow :: Int
    , cellCol :: Int 
    } deriving (Generic, Show)

instance A.FromJSON ClickData
instance A.ToJSON ClickData