
module Hhhhoard.GoogleAuth
  (getGoogleAuthValue
  ,GoogleAuth(..)
  )
where

import Hhhhoard.Types

import Network.Curl

import Control.Applicative
import Control.Monad
import Control.Monad.Trans
import Control.Monad.Maybe

-- Auth, Token
-- Rewrite this to use OAuth?
getGoogleAuthValue :: Email -> Password -> MaybeT IO GoogleAuth
getGoogleAuthValue email password = do
  (c, response) <- lift $ curlGetString loginUrl [CurlPostFields post]
  guard (c == CurlOK)
  case lookupField "Auth" response of
    Just auth -> GoogleAuth auth <$> getGoogleTokenValue auth
    Nothing   -> mzero
  where
    post = ["Email=" ++ email, "Passwd=" ++ password, "service=reader"]
    getGoogleTokenValue auth = do
      let options = [CurlHttpHeaders ["Authorization: GoogleLogin auth="++auth]]
      (_, response) <- lift $ curlGetString (tokenUrl++"token") options
      return response


lookupField :: String -> String -> Maybe String
lookupField field resp =
  rmIfAtStart '=' <$> lookup field params
  where splitBy c = span (/= c)
        params = map (splitBy '=') (lines resp)
        rmIfAtStart c s@(x:xs)
          | x == c = xs
          | otherwise = s
        rmIfAtStart _ s = s
