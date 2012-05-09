
module Hhhhoard.Utils
 ( downloadFile
 , extractOriginalUrl
 ) where

import Data.List
import System.IO
import System.FilePath.Posix
import Network.Curl.Download
import qualified Data.ByteString as B

import Hhhhoard.Types

downloadFile :: FilePath -> URLString -> IO (Either String Bool)
downloadFile path dlurl = 
  withBinaryFile (path </> urlToFile dlurl) WriteMode writeContents
  where
    urlToFile = fst . span (/='?') . takeFileName
    writeContents h = do
      ret <- openURI dlurl
      case ret of
        Left  er -> return (Left er)
        Right bs -> do { B.hPut h bs; return (Right True) }

{- Extract original URL from ffffound -}
extractOriginalUrl :: String -> Maybe String
extractOriginalUrl doc
  | null doc               = Nothing
  | start `isPrefixOf` doc = Just (takeWhile (/= '"') $ drop (length start) doc)
  | otherwise              = extractOriginalUrl $ drop 1 doc
  where
    start = "-link-img\" href=\"" 
