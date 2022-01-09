module AnpanEditor.Capability.Nyan where

import Prelude

import Control.Monad.Trans.Class (lift)
import Effect.Aff.Class (class MonadAff)
import Halogen (HalogenM(..))
import Halogen.Hooks as Hooks

class MonadAff m <= Nyan m where
  nyan :: String -> m String

instance Nyan m => Nyan (HalogenM st act slot msg m) where
  nyan = lift <<< nyan

instance Nyan m => Nyan (Hooks.HookM m) where
  nyan = lift <<< nyan