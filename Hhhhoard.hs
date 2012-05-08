

module Main where

import Hhhhoard.Types
import Hhhhoard.Parse
import Hhhhoard.GoogleAuth
import Hhhhoard.Entries
import Hhhhoard.Creds

import Network.Curl
import Network.Curl.Download.Lazy

import qualified Data.ByteString.Lazy.Char8 as L

import Control.Monad
import Control.Monad.Trans
import Control.Monad.Maybe


{- Google fetch functions -}
kept_unread_url :: URLString
kept_unread_url = base ++ feed ++ "?" ++ args
  where
    base = "https://www.google.com/reader/atom/feed/"
    feed = "http%3A%2F%2Ffeeds.feedburner.com%2Fffffound%2Feveryone"
    args = "n=1000&xt=user%2f-%2fstate%2fcom.google%2fread"

getUnread :: GoogleAuth -> IO L.ByteString
getUnread auth = do
  dl <- (flip openLazyURIWithOpts) kept_unread_url opts
  case dl of
    Left  _  -> return L.empty
    Right bs -> return bs

  where
    headers = ["Authorization:GoogleLogin auth="++(getAuth auth)]
    opts    = [CurlHttpHeaders headers, CurlSSLVerifyPeer False]


hoard :: MaybeT IO ()
hoard =
  do -- get an auth token
    auth <- getGoogleAuthValue userEmail userPassword

    lift $ do 
      xml <- getUnread auth

      entries <- extractFfffoundEntries . L.unpack $ xml

      forM_ entries ( modifyEntryWithNewUrl >=> -- get the original URL
                      downloadEntry >=>         -- download it
                      markEntryAsRead auth)     -- mark it as read
        

main :: IO (Maybe ())
main = runMaybeT hoard
