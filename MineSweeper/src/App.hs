module App
    ( startApp
    ) where

import MineSweeper.Types
    ( GameState(..)
    , CellState(..)
    , Cell(..)
    , Status(..)
    )

import MineSweeper.Web
    ( gamePage
    )

import Web.Scotty as S
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text (renderHtml)

import Network.Wai.Middleware.Static

import Control.Monad.IO.Class (liftIO)
import Data.IORef

import qualified Data.Map as Map
import MineSweeper.Game
import Data.Text.Lazy (Text, pack)



startApp :: IO ()
startApp = do
    gameState <- initialGameState
    scotty 3000 $ do
        middleware $ staticPolicy (noDots >-> addBase "static")
        get (literal "/") $ do
            S.html $ renderHtml gamePage

        post (literal "/click/:row/:col") $ do
            row <- S.pathParam (Data.Text.Lazy.pack "row")
            col <- S.pathParam (Data.Text.Lazy.pack "col")
            state <- liftIO $ readIORef gameState
            liftIO $ modifyIORef gameState (handleClick row col)
            redirect (Data.Text.Lazy.pack "/")


