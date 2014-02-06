module Web.Mp3Convertr where

import           System.FilePath.Posix (combine)
import           System.Process (readProcess)

data ConvertConf = ConvertConf  { getFFmpegCommand :: FilePath
                                , getTempDir :: FilePath
                                , getExt :: String
                                , getDestDir :: FilePath
                                , getBitRate :: Int
                                , getSamplingRate :: Int
                                } deriving (Show, Read, Eq)

convertToMp3 :: ConvertConf-> String -> IO String
convertToMp3 (ConvertConf cmd tmp ext dir b r) v = readProcess cmd ["-i", tmpPath, "-ab", bitRate, "-ar", samplingRate, destFilePath] []
    where
        tmpPath = combine tmp (v ++ ext)
        destFilePath = combine dir (v ++ ".mp3")
        bitRate = show b
        samplingRate = show r
