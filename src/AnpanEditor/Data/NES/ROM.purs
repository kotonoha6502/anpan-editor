module AnpanEditor.Data.NES.ROM
  ( ROM
  , RomSpec
  , romSpecCodec
  )
  where

import AnpanEditor.Data.NES.Mirroring (Mirroring, mirroringCodec)
import Data.ArrayBuffer.Types (Uint8Array)
import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR

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

type ROM =
  { header :: Uint8Array
  , prg :: Uint8Array
  , chr :: Uint8Array
  }
