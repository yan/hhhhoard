{-# LANGUAGE Arrows #-}

module Hhhhoard.Parse
 (
   extractEntry
 , extractFfffoundEntries
) where

import Hhhhoard.Types

import Prelude hiding (elem)
import Data.List hiding (elem)

import Text.XML.HXT.Core
-- import Text.XML.HXT.Curl

{- XML parsing functions -}
extractEntry :: IOSLA (XIOState ()) XmlTree FfffoundEntry
extractEntry
  = atTag "entry" >>> (from "ffffound" `guards` this) >>> 
      proc ent -> do
        title   <- text                  <<< elem "title"        -< ent
        url     <- getAttrValue "href"   <<< elem "link"         -< ent
        author  <- text <<< atTag "name" <<< atTag "author"      -< ent
        entryid <- textelem "id"                                 -< ent
        returnA -< Entry { entryTitle = title , entryAuthor = author
                         , entryUrl = url     , entryId = entryid  }
    where
      atTag tag  = deep (isElem >>> hasName tag)
      from src   = getChildren >>> atTag "source" >>> 
                    hasAttrValue "gr:stream-id" (isInfixOf src)
      text       = getChildren >>> getText
      elem t     = getChildren >>> hasName t
      textelem t = elem t >>> getChildren >>> getText

extractFfffoundEntries :: String -> IO [FfffoundEntry]
extractFfffoundEntries xml = runX (readString [withValidate no] xml
                                   >>> extractEntry)
