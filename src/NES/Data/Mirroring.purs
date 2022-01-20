module NES.Data.Mirroring
  ( Mirroring(..)
  , display
  , mirroringCodec
  , parse
  )
  where

import Prelude

import Data.Codec.Argonaut (JsonCodec, prismaticCodec)
import Data.Codec.Argonaut as CA
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Show.Generic (genericShow)
import Data.String (toLower, trim)

data Mirroring = Vertical | Horizontal

derive instance Eq Mirroring
derive instance Ord Mirroring
derive instance Generic Mirroring _
instance Show Mirroring where
  show = genericShow

display :: Mirroring -> String
display = case _ of
  Vertical -> "vertical"
  Horizontal -> "horizontal"

parse :: String -> Maybe Mirroring
parse = trim >>> toLower >>> case _ of
  "vertical" -> Just Vertical
  "horizontal" -> Just Horizontal
  _ -> Nothing

mirroringCodec :: JsonCodec Mirroring
mirroringCodec = prismaticCodec "Mirroring" parse display CA.string