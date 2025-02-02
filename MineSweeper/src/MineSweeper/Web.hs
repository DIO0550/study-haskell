module MineSweeper.Web where

import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A

gamePage :: Html
gamePage = docTypeHtml $ do
    H.head $ do
        H.title $ toHtml "マインスイーパー"
        H.head $ do
            H.link ! A.rel (toValue "stylesheet") 
                    ! A.type_ (toValue "text/css")
                    ! A.href (toValue "style.css")

            H.script ! A.src (toValue "script.js")  
                    ! A.type_ (toValue "text/javascript") $ mempty
    H.body $ do
        H.div ! A.class_ (toValue "game-board") $ do
            sequence_ [
                H.div ! A.class_ (toValue $ "row") $
                    sequence_ [
                        H.div ! A.class_ (toValue "cell") !
                            A.id (toValue $ "cell-" ++ show r ++ "-" ++ show c) $ do
                            H.button ! A.onclick (toValue $ "return handleClick(" ++ show r ++ "," ++ show c ++ ")")
                                   $ toHtml "□"
                                
                            | c <- [0..7]
                        ]
                    | r <- [0..7]
                ]
            H.div $ toHtml ""