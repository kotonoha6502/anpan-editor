module AnpanEditor.Electron.ExposedAPI
  ( loadRomFile
  , onRomFileSelected
  )
  where

import Prelude

import AnpanEditor.Data.NES.ROM (ROM, romSpecCodec)
import AnpanEditor.Data.NES.VirtualROM (RomMetaInfo, VROM, vrom)
import Control.Promise (Promise, toAffE)
import Data.Argonaut.Core (Json)
import Data.Codec.Argonaut (decode)
import Data.Either (Either(..))
import Data.Function.Uncurried (Fn3, runFn3)
import Effect (Effect)
import Effect.Aff (Aff, Error, error)
import Effect.Class (liftEffect)
import Effect.Exception (throwException)
import Node.Path (FilePath)


loadRomFile :: FilePath -> Aff VROM
loadRomFile path = do
  res <- toAffE $ runFn3 _loadRomFile Left Right path
  case res of
    Left error -> liftEffect $ throwException error
    Right { romSpec: json, meta, base } -> do
      let decoded = decode romSpecCodec json
      case decoded of
        Left _ -> liftEffect $ throwException $ error "Invalid RomSpec."
        Right romSpec -> liftEffect $ vrom meta romSpec base
    
foreign import onRomFileSelected :: (FilePath -> Effect Unit) -> Effect Unit

foreign import _loadRomFile :: 
  Fn3 
    (forall a b. a -> Either a b)
    (forall a b. b -> Either a b)
    FilePath
    (Effect (Promise (Either Error { romSpec :: Json
                                   , meta :: RomMetaInfo
                                   , base :: ROM
                                   })))
