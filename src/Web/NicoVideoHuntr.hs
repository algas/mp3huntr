module Web.NicoVideoHuntr where

import           Control.Applicative    ((<$>))
import           Data.ByteString.Char8  (pack, unpack)
import           Network.HTTP.Types.URI (parseQuery)
import           Network.URI            (URI, parseURI, uriAuthority, uriPath,
                                         uriQuery, uriRegName, uriScheme)
import           System.FilePath.Posix  (combine)
import           System.Process         (readProcess)

data NicoVideoConf = NicoVideoConf  { getNicoVideoCommand :: FilePath
                                    , getTempDir          :: FilePath
                                    , getExt              :: String
                                    , getUserName         :: String
                                    , getPassWord         :: String
                                    } deriving (Show, Read, Eq)

nicovideoUrl :: String
nicovideoUrl = "http://www.nicovideo.jp/watch/"

isNicoVideoURI :: URI -> Bool
isNicoVideoURI url   = ("http:" == scheme)
                    && (Just "www.nicovideo.jp" == regName)
                    && ("/watch/" == take 7 path)
    where
        scheme  = uriScheme url
        regName = uriRegName <$> uriAuthority url
        path    = uriPath url

getNicoVideoName :: String -> Maybe String
getNicoVideoName url = do
    u <- parseURI url
    Just $ drop 7 $ uriPath u

downloadNicoVideo :: NicoVideoConf -> String -> IO String
downloadNicoVideo (NicoVideoConf c t e u p) v = readProcess command ["-u", u, "-p", p, "-o", tmpPath, url] []
    where
        command = c
        tmpPath = combine t (v ++ e)
        url = nicovideoUrl ++ v

