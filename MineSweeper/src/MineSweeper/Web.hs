module MineSweeper.Web where

import Web.Scotty as S
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html.Renderer.Text (renderHtml)

gamePage :: Html
gamePage = docTypeHtml $ do
    H.head $ do
        H.title $ toHtml "マインスイーパー"
        H.head $ do
            H.link ! A.rel (toValue "stylesheet") !
                    A.href (toValue "/static/style.css")
    H.body $ do
        H.div ! A.class_ (toValue "game-board") $ do
            sequence_ [
                H.div ! A.class_ (toValue "cell") !
                      A.id (toValue $ "cell-" ++ show r ++ "-" ++ show c) $ do
                    H.form ! A.method (toValue "post") !
                           A.action (toValue $ "/click/" ++ show r ++ "/" ++ show c) $ do
                        H.button $ toHtml "□"
                    | r <- [0..7], c <- [0..7]  -- 8x8のマス目を生成
                ]
            H.div $ toHtml ""