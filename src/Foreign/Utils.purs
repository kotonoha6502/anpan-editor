module Foreign.Utils where

import Prelude

import Effect (Effect)
import Effect.Ref (Ref)

foreign import unsafeConsoleLog :: forall a. a -> Effect Unit


foreign import mutateArrayPush :: forall a. a -> Ref (Array a) -> Effect Int