module Main where

import           Test.Hspec
import           Test.YouTubeHuntrSpec (youTubeSpec)
import           Test.NicoVideoHuntrSpec (nicoVideoSpec)


main :: IO ()
main = do
    hspec youTubeSpec
    hspec nicoVideoSpec
