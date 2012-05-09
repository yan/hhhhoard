
module Hhhhoard.Types
  ( GoogleAuth(..)
  , FfffoundEntry(..)
  , Email
  , Password
  , URLString
  , tokenUrl
  , loginUrl
  ) where

import Network.Curl (URLString)

data GoogleAuth = GoogleAuth {
                       getAuth :: String
                     , getToken :: String
                  }
data FfffoundEntry = Entry {
                        entryTitle, entryAuthor :: String
                      , entryId :: String
                      , entryUrl :: URLString
                     } deriving (Show)

type Email = String
type Password = String

tokenUrl :: String
tokenUrl = "https://www.google.com/reader/api/0/"
loginUrl :: String
loginUrl  = "https://www.google.com/accounts/ClientLogin"

