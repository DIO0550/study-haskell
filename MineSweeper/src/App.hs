{-# LANGUAGE OverloadedStrings #-}
module App
    ( startApp
    ) where

import MineSweeper.Types
    ( GameState(..)
    , CellState(..)
    , Cell(..)
    , Status(..)
    , ClickResult(..)
    )

import MineSweeper.Web
    ( gamePage
    )

import Web.Scotty as S
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text (renderHtml)

import Network.Wai.Middleware.Static
import Network.Wai (pathInfo, requestMethod, rawPathInfo)

import Control.Monad.IO.Class (liftIO)
import Data.IORef

import qualified Data.Map as Map
import MineSweeper.Game hiding (pack)
import Data.Text.Lazy (Text, pack)
import qualified MineSweeper.Types
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Aeson as A  
import Data.Aeson ((.=), ToJSON, Key)
import Data.String (fromString)
import qualified Data.Text
import qualified Data.Text as T



startApp :: IO ()
startApp = do
    gameState <- initialGameState
    scotty 3000 $ do
        middleware $ staticPolicy (noDots >-> addBase "static")

        get "/" $ do
            S.html $ renderHtml gamePage

        get "/click/:row/:col" $ do 
            row <- S.pathParam (pack "row")  -- String -> Text に変換
            col <- S.pathParam (pack "col")

            gstate <- liftIO $ readIORef gameState

            liftIO $ modifyIORef gameState (handleClick row col)
            newState <- liftIO $ readIORef gameState


            let result = ClickResult (gameStatus newState) ( board newState Map.! (row, col) )
            let jsonByteString = A.encode result
            liftIO $ BL.putStrLn jsonByteString  -- liftIOを使ってIOアクションを持ち上げる

            let jsonString = BL.unpack jsonByteString
            json jsonString
        