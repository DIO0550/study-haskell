{-# LANGUAGE OverloadedStrings #-}
module App
    ( startApp
    ) where

import MineSweeper.Types
    ( GameState(..)
    , cellRow
    , cellCol
    , ClickResult(..), ClickData, Cell (Cell), CellState (Closed)
    )

import MineSweeper.Web
    ( gamePage
    )

import MineSweeper.Cell
    ( openCell
    , toggleFlag

    )

import Web.Scotty as S
import Text.Blaze.Html.Renderer.Text (renderHtml)

import Network.Wai.Middleware.Static

import Data.IORef

import qualified Data.Map as Map
import MineSweeper.Game hiding (
    pack)




startApp :: IO ()
startApp = do
    gameState <- initialGameState
    scotty 3000 $ do
        middleware $ staticPolicy (noDots >-> addBase "static")

        get "/" $ do
            S.html $ renderHtml gamePage

        post "/flag" $ do
            clickData <- jsonData :: ActionM ClickData

            let row = cellRow clickData
            let col = cellCol clickData
        

            liftIO $ modifyIORef gameState (toggleFlag row col)
            newState <- liftIO $ readIORef gameState

            let result = ClickResult (gameStatus newState) ( board newState Map.! (row, col) )
            setHeader "Content-Type" "application/json"
            json result

        post "/click" $ do
            clickData <- (jsonData :: ActionM ClickData) `rescue` \errorMsg -> do
                status status400
                json $ object ["error" .= errorMsg, "status" .= "failed"]
                finish

            let row = cellRow clickData
            let col = cellCol clickData

            liftIO $ modifyIORef gameState (openCell row col)
            newState <- liftIO $ readIORef gameState

            -- TODO: ここでゲームオーバーの状態を確認する

            let result = ClickResult (gameStatus newState) ( board newState Map.! (row, col) )

            setHeader "Content-Type" "application/json"
            json result

        get "reset" $ do
            liftIO $ modifyIORef gameState resetGame
            newState <- liftIO $ readIORef gameState
            let result = ClickResult (gameStatus newState) ( Cell False Closed 0 )
            setHeader "Content-Type" "application/json"
            json result

