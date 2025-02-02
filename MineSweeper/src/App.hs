{-# LANGUAGE OverloadedStrings #-}
module App
    ( startApp
    ) where

import MineSweeper.Types
    ( GameState(..)
    , cellRow
    , cellCol
    , ClickResult(..), ClickData
    )

import MineSweeper.Web
    ( gamePage
    )

import Web.Scotty as S
import Text.Blaze.Html.Renderer.Text (renderHtml)

import Network.Wai.Middleware.Static

import Data.IORef

import qualified Data.Map as Map
import MineSweeper.Game hiding (pack)
import Data.Text.Lazy (pack)
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Aeson as A  



startApp :: IO ()
startApp = do
    gameState <- initialGameState
    scotty 3000 $ do
        middleware $ staticPolicy (noDots >-> addBase "static")

        get "/" $ do
            S.html $ renderHtml gamePage

        post "/click" $ do 
            clickData <- jsonData :: ActionM ClickData

            let row = cellRow clickData
            let col = cellCol clickData

            liftIO $ modifyIORef gameState (handleClick row col)
            newState <- liftIO $ readIORef gameState


            let result = ClickResult (gameStatus newState) ( board newState Map.! (row, col) )
            -- let jsonByteString = A.encode result
            -- liftIO $ BL.putStrLn jsonByteString  -- liftIOを使ってIOアクションを持ち上げる

            setHeader "Content-Type" "application/json"
            json result 
        