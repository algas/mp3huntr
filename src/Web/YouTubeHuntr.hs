module Web.YouTubeHuntr where

import           Control.Applicative    ((<$>))
import           Data.ByteString.Char8  (pack, unpack)
import           Network.HTTP.Types.URI (parseQuery)
import           Network.URI            (URI, parseURI, uriAuthority, uriPath,
                                         uriQuery, uriRegName, uriScheme)
import           System.FilePath.Posix  (combine)
import           System.Process         (readProcess)

data YouTubeConf = YouTubeConf  { getYouTubeCommand :: FilePath
                                , getTempDir        :: FilePath
                                , getExt            :: String
                                } deriving (Show, Read, Eq)

youtubeUrl :: String
youtubeUrl = "http://www.youtube.com/watch?v="

isYouTubeURI :: URI -> Bool
isYouTubeURI url = ("http:" == scheme)
                && (Just "www.youtube.com" == regName)
                && ("/watch" == path)
                && (elem "v" query)
    where
        scheme  = uriScheme url
        regName = uriRegName <$> uriAuthority url
        path    = uriPath url
        query   = map (unpack . fst) $ parseQuery $ pack $ uriQuery url

getYouTubeName :: String -> Maybe String
getYouTubeName url = do
    u <- parseURI url
    Just $ drop 3 $ uriQuery u

downloadYouTube :: YouTubeConf -> String -> IO String
downloadYouTube (YouTubeConf c t e) v = readProcess command ["-o", tmpPath, url] []
    where
        command = c
        tmpPath = combine t (v ++ e)
        url = youtubeUrl ++ v
