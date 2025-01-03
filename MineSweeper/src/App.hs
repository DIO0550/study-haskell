module App
    ( startApp
    ) where

import Web.Scotty
import Data.Text.Lazy (pack)
import Data.String (fromString) 

startApp :: IO ()
startApp = scotty 3000 $ do
    get (fromString "/hello") $ do
        text $ pack "Hello, World!"