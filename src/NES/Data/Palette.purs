module NES.Data.Palette
  ( Color
  , Colors
  , Palette
  )
  where


import Data.UInt (UInt)

type Color = UInt

type Colors = { fst :: Color, snd :: Color, trd :: Color }

type Palette =
  { backdrop :: Color
  , left :: { fst :: Colors, snd :: Colors, trd :: Colors, fth :: Colors }
  , right :: { fst :: Colors, snd :: Colors, trd :: Colors, fth :: Colors }
  }