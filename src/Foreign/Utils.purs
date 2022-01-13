module Foreign.Utils where

import Prelude

import Effect (Effect)

foreign import unsafeConsoleLog :: forall a. a -> Effect Unit
