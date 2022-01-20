module AnpanEditor.Data.NES.VirtualROM
  ( Change
  , RomArea(..)
  , RomMetaInfo
  , VROM
  , getCurrentBase
  , patch
  , revert
  , runVROM
  , vrom
  )
  where

import Prelude hiding ((+))

import Data.List (List(..))
import Effect (Effect)
import Effect.Ref (Ref)
import Effect.Ref as Ref
import NES.Data.ROM (RomSpec, ROM)
import Node.Buffer (Buffer, Octet)
import Node.Path (FilePath)

data RomArea = Trainer | PRG | CHR
derive instance Eq RomArea
derive instance Ord RomArea

instance Show RomArea where
  show = case _ of
    Trainer -> "Trainer"
    PRG -> "PRG"
    CHR -> "CHR"
    

type Change = 
  { in :: RomArea
  , at :: Int
  , from :: Octet
  , to :: Octet
  }

newtype VROM = VROM
  { romSpec :: RomSpec
  , meta :: RomMetaInfo
  , base :: ROM
  , changes ::
    { done :: Ref (Array Change)
    , undone :: List Change
    }
  }

getCurrentBase :: VROM -> ROM
getCurrentBase (VROM vrom) = vrom.base

foreign import unsafeShowBuf :: Buffer -> String

type RomMetaInfo = 
  { filename :: String
  , directory :: FilePath
  }

vrom :: RomMetaInfo -> RomSpec ->  ROM -> Effect VROM
vrom meta romSpec base = do
  done <- Ref.new []
  pure $ VROM $
    { romSpec
    , meta
    , base
    , changes:
      { done
      , undone: Nil
      }
    }

patch :: ROM -> Change -> Effect ROM
patch rom change = pure rom

revert :: Change -> ROM -> Effect ROM
revert change rom = pure rom

runVROM :: VROM -> Effect ROM
runVROM (VROM vrom) = do
  pure vrom.base
