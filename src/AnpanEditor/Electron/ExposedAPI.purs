module AnpanEditor.Electron.ExposedAPI 
  ( nyan
  ) where

import Prelude

import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff)

nyan :: String -> Aff String
nyan = toAffE <<< _nyan

foreign import _nyan :: String -> Effect (Promise String)
