module Test.NicoVideoHuntrSpec where

import           Control.Applicative ((<$>))
import           Network.URI         (parseURI)
import           Test.Hspec
import           Web.NicoVideoHuntr  (isNicoVideoURI, nicovideoUrl)


nicoVideoSpec :: Spec
nicoVideoSpec = do
    describe "nicovideoUrl" $ do
        it "nicovideoUrl is " $
            nicovideoUrl `shouldBe` "http://www.nicovideo.jp/watch/"
    describe "isNicoVideoURI" $ do
        it "http://www.nicovideo.jp/watch/foobar isNicoVideoURI" $
            (isNicoVideoURI <$> parseURI "http://www.nicovideo.jp/watch/foobar") `shouldBe` Just True
        it "https://jp.nicovideo.jp/ isNicoVideoURI" $
            (isNicoVideoURI <$> parseURI "https://jp.nicovideo.jp/foo/bar") `shouldBe` Just False

