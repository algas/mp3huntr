module Test.YouTubeHuntrSpec where

import           Control.Applicative ((<$>))
import           Network.URI         (parseURI)
import           Test.Hspec
import           Web.YouTubeHuntr    (isYouTubeURI, youtubeUrl)


youTubeSpec :: Spec
youTubeSpec = do
    describe "youTubeUrl" $ do
        it "youtubeUrl is " $
            youtubeUrl `shouldBe` "http://www.youtube.com/watch?v="
    describe "isYouTubeURI" $ do
        it "http://www.youtube.com/watch?v=foobar isYouTubeURI" $
            (isYouTubeURI <$> parseURI "http://www.youtube.com/watch?v=foobar") `shouldBe` Just True
        it "https://jp.youtube.com/ isYouTubeURI" $
            (isYouTubeURI <$> parseURI "https://jp.youtube.com/hoge?foo=bar") `shouldBe` Just False

