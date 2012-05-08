
module Hhhhoard.GoogleAuth
  (getGoogleAuthValue
  ,GoogleAuth(..)
  )
where

import Hhhhoard.Types

import Network.Curl

import Control.Monad
import Control.Monad.Trans
import Control.Monad.Maybe

-- Auth, Token
-- Rewrite this to use OAuth?
getGoogleAuthValue :: Email -> Password -> MaybeT IO GoogleAuth
getGoogleAuthValue email password = do
  (c, response) <- lift $ curlGetString svc [CurlPostFields post]
  guard (c == CurlOK)
  case lookupField "Auth" response of
    Just auth -> do 
                   token <- getGoogleTokenValue auth
                   return (GoogleAuth auth token)
    Nothing   -> mzero
  where
    post = ["Email="++email, "Passwd="++password, "service=reader"]
    svc = "https://www.google.com/accounts/ClientLogin"
    getGoogleTokenValue auth = do
      (_, response) <- lift $ curlGetString (tokenUrl++"token")
                                                      [CurlHttpHeaders headers
                                                      ,CurlSSLVerifyPeer False]
      return response
      where
        headers = ["Authorization: GoogleLogin auth="++auth]


lookupField :: String -> String -> Maybe String
lookupField field resp =
  rmIfAtStart '=' `fmap` lookup field params
  where splitBy c = span (/= c)
        params = map (splitBy '=') (lines resp)
        rmIfAtStart c s@(x:xs)
          | x == c = xs
          | otherwise = s
        rmIfAtStart _ s = s
