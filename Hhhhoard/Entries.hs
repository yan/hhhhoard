
module Hhhhoard.Entries
 ( markEntryAsRead
 , downloadEntry
 , modifyEntryWithNewUrl 
 )
where

import Hhhhoard.GoogleAuth
import Hhhhoard.Types
import Hhhhoard.Utils

import Data.URLEncoded (export, urlEncode)
import Network.Curl

downloadEntry :: FfffoundEntry -> IO (Maybe FfffoundEntry)
downloadEntry entry =
  do 
   result <- (downloadFile "imgs/" . entryUrl) entry
   case result of
     Left er -> do putStrLn $ "Failed: " ++ (entryUrl entry) ++ ": " ++ er
                   return Nothing
     Right _ -> do putStrLn $ "Downloaded: " ++ (entryUrl entry)
                   return (Just entry)

-- http://code.google.com/p/pyrfeed/wiki/GoogleReaderAPI
markEntryAsRead :: GoogleAuth -> Maybe FfffoundEntry -> IO ()
markEntryAsRead auth (Just entry) =
  do
    let editTagUrl = tokenUrl ++ "edit-tag"
    (_, _) <- curlGetString (editTagUrl)
                              [CurlPostFields . map (export . urlEncode) $ post
                              ,CurlHttpHeaders headers]
    return ()
    where
      post = [("i", entryId entry)
             ,("a", "user/-/state/com.google/read")
             ,("r", "user/-/state/com.google/kept-unread")
             ,("ac","edit")
             ,("T", getToken auth)]
      headers = ["Authorization: GoogleLogin auth="++(getAuth auth)]
{- should output an error message, but if we don't download the image correctly,
  show an error -}
markEntryAsRead _ Nothing = return ()


modifyEntryWithNewUrl :: FfffoundEntry -> IO (FfffoundEntry)
modifyEntryWithNewUrl entry = do
  (_, str) <- curlGetString (entryUrl entry) []
  return $ case extractOriginalUrl str of
    Just jurl -> entry { entryUrl = jurl }
    Nothing   -> entry

