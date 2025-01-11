module App
    ( startApp
    ) where

import Web.Scotty as S
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text (renderHtml)
import Data.Text.Lazy (Text, pack)
import Control.Monad.IO.Class (liftIO)
import Data.IORef
import qualified Data.Map as Map

-- ゲームの状態
data GameState = GameState {
    board :: Map.Map (Int, Int) Cell,
    gameStatus :: Status
}

data Cell = Cell {
    hasMine :: Bool,
    isRevealed :: Bool,
    neighborMines :: Int
} deriving Show

data Status = Playing | GameOver | Won deriving Show



-- 初期状態
initialGameState :: IO (IORef GameState)
initialGameState = newIORef $ GameState {
    board = Map.empty,
    gameStatus = Playing
}

startApp :: IO ()
startApp = do
    gameState <- initialGameState
    scotty 3000 $ do
        get (literal "/") $ do
            S.html $ renderHtml gamePage

        post (literal "/click/:row/:col") $ do
            row <- S.pathParam (Data.Text.Lazy.pack "row")
            col <- S.pathParam (Data.Text.Lazy.pack "col")
            state <- liftIO $ readIORef gameState
            liftIO $ modifyIORef gameState (handleClick row col)
            redirect (Data.Text.Lazy.pack "/")

handleClick :: Int -> Int -> GameState -> GameState
handleClick row col state = 
    case gameStatus state of
        Playing -> state { board = Map.adjust revealCell (row, col) (board state) }
        _ -> state

revealCell :: Cell -> Cell
revealCell cell = cell { isRevealed = True }

pack :: String -> Text
pack = Data.Text.Lazy.pack

gamePage :: Html
gamePage = docTypeHtml $ do
    H.head $ do
        H.title $ toHtml "マインスイーパー"
    H.body $ do
        H.div ! A.class_ (toValue "game-container") $ do
            H.form ! A.method (toValue "post") ! A.action (toValue "/click/0/0") $ do
                H.button $ toHtml "クリック"