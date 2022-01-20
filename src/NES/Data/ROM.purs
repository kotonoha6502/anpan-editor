module NES.Data.ROM
  ( Addr
  , ROM
  , ROMrep
  , RomSpec
  , _chr
  , _prg
  , part
  , romSpecCodec
  )
  where

import Prelude

import Data.ArrayBuffer.DataView (whole)
import Data.ArrayBuffer.DataView as AB
import Data.ArrayBuffer.Typed (buffer)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Data.Maybe (Maybe(..))
import Data.Symbol (class IsSymbol)
import Data.UInt (UInt)
import Effect (whileE)
import Effect.Class (class MonadEffect, liftEffect)
import Effect.Ref as Ref
import Foreign.Utils (mutateArrayPush)
import NES.Data.Mirroring (Mirroring, mirroringCodec)
import Prim.Row (class Cons)
import Record as Record
import Type.Proxy (Proxy(..))

type RomSpec = 
  { prgRomSize :: Int
  , chrRomSize :: Int
  , mirroring :: Mirroring
  , hasBatteryRAM :: Boolean
  , hasTrainer :: Boolean
  , fourScreenMirroring :: Boolean
  , mapper :: Int
  }

romSpecCodec :: JsonCodec RomSpec
romSpecCodec = CAR.object "RomSpec" ({
    prgRomSize: CA.int,
    chrRomSize: CA.int,
    mirroring: mirroringCodec,
    hasBatteryRAM: CA.boolean,
    hasTrainer: CA.boolean,
    fourScreenMirroring: CA.boolean,
    mapper: CA.int
  })

type ROMrep =
  ( prg :: Uint8Array
  , chr :: Uint8Array
  )

type ROM = { | ROMrep }

type Addr = Int

_prg :: Proxy  "prg"
_prg = Proxy

_chr :: Proxy "chr"
_chr = Proxy

class IsSymbol k <= IsRomKind k
instance IsRomKind "prg"
instance IsRomKind "chr"

part :: forall l m t
      . IsSymbol l
     => Cons l Uint8Array t ROMrep
     => MonadEffect m
     => ROM -> Proxy l -> Addr -> Int -> m (Array UInt)
part rom proxy addr length = liftEffect do 
  
  let romDataView = whole $ buffer $ Record.get proxy rom

  i <- Ref.new 0
  shouldContinue <- Ref.read i >>= \j -> Ref.new (j < length)
  result <- Ref.new []

  whileE (Ref.read shouldContinue) do
    mv <- Ref.read i >>= (_ + addr) >>> AB.getUint8 romDataView
    case mv of
      Nothing -> Ref.modify_ (const false) shouldContinue
      Just v -> do
        void $ mutateArrayPush v result
        next <- Ref.modify (_ + 1) i
        Ref.modify_ (const $ next < length) shouldContinue

  Ref.read result