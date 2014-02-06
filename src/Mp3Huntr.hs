{-# LANGUAGE OverloadedStrings #-}
module Main where

import           Control.Monad          (join)
import           Control.Monad.Error    (runErrorT)
import           Control.Monad.IO.Class (liftIO)
import qualified Data.ConfigFile        as CF
import           Data.Maybe             (fromJust)
import           Data.Text.Lazy         (pack)
import           Network.URI            (URI, parseURI)
import           System.Environment     (getArgs)
import           Web.Mp3Convertr        (ConvertConf, ConvertConf (..),
                                         convertToMp3)
import           Web.NicoVideoHuntr     (NicoVideoConf, NicoVideoConf (..),
                                         downloadNicoVideo, getNicoVideoName,
                                         isNicoVideoURI)
import           Web.Scotty
import           Web.YouTubeHuntr       (YouTubeConf, YouTubeConf (..),
                                         downloadYouTube, getYouTubeName,
                                         isYouTubeURI)

rootAction :: ActionM ()
rootAction = html "hello"

youTubeAction :: YouTubeConf -> ConvertConf -> String -> ActionM ()
youTubeAction y c d = do
    liftIO $ downloadYouTube y v
    liftIO $ convertToMp3 c v
    html $ pack v
    where v = fromJust $ getYouTubeName d

nicoVideoAction :: NicoVideoConf -> ConvertConf -> String -> ActionM ()
nicoVideoAction n c d = do
    liftIO $ downloadNicoVideo n v
    liftIO $ convertToMp3 c v
    html $ pack v
    where v = fromJust $ getNicoVideoName d

downloadAction :: YouTubeConf -> NicoVideoConf -> ConvertConf -> String -> ActionM ()
downloadAction y n c v
    | uri == Nothing   = html $ "Invalid URL!"
    | isYouTubeURI u   = youTubeAction y c v
    | isNicoVideoURI u = nicoVideoAction n c v
    | otherwise        = html $ "No video URL!"
    where
        uri = parseURI v
        u   = fromJust uri

tempExt :: String
tempExt = ".mp4"

main :: IO ()
main = do
    argv <- getArgs
    let configFilePath = argv !! 0
    rv <- runErrorT $ do
        cp <- join $ liftIO $ CF.readfile CF.emptyCP configFilePath
        port <- CF.get cp "DEFAULT" "port"
        youtubeCmd <- CF.get cp "DEFAULT" "youtubecmd"
        nicovideoCmd <- CF.get cp "DEFAULT" "nicovideocmd"
        ffmpegCmd <- CF.get cp "DEFAULT" "ffmpegcmd"
        bitRate <- CF.get cp "DEFAULT" "bitrate"
        samplingRate <- CF.get cp "DEFAULT" "samplingrate"
        tempDir <- CF.get cp "DEFAULT" "tempdir"
        destDir <- CF.get cp "DEFAULT" "destdir"
        nicoUser <- CF.get cp "DEFAULT" "nicouser"
        nicoPass <- CF.get cp "DEFAULT" "nicopass"
        let youTubeConf = YouTubeConf youtubeCmd tempDir tempExt
        let nicovideoConf = NicoVideoConf nicovideoCmd tempDir tempExt nicoUser nicoPass
        let convertConf = ConvertConf ffmpegCmd tempDir tempExt destDir bitRate samplingRate
        liftIO $ scotty port $ do
            get "/" $ do
                rootAction
            get "/download" $ do
                d <- param "url"
                downloadAction youTubeConf nicovideoConf convertConf d
        return "done"
    print rv
