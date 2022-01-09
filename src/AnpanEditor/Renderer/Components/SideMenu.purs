module AnpanEditor.Renderer.Components.SideMenu where

import Prelude

import AnpanEditor.Renderer.Route (Route(..))
import AnpanEditor.Renderer.Store as S
import Data.Maybe (fromMaybe)
import Halogen (ClassName(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.Store.Monad (class MonadStore, updateStore)
import Halogen.Store.UseSelector (useSelector)


sideMenu :: forall q i o m
          . MonadStore S.Action S.Store m
         => H.Component q i o m
sideMenu = Hooks.component \_ _ -> Hooks.do
  ctx <- useSelector S.selectCurrentView

  Hooks.pure do
    let currentTab = fromMaybe TitleEditor ctx
    HH.div [HP.class_ $ ClassName "side-menu is-flex is-flex-direction-column is-align-items-center"]
      [ HH.div
          [ HP.class_ $ ClassName $ "side-menu-btn side-menu-btn__title " <> (if currentTab == TitleEditor then "is-active" else "")
          , HE.onClick \_ -> updateStore (S.UpdateView TitleEditor)
          ] []
      , HH.div
          [ HP.class_ $ ClassName $ "side-menu-btn side-menu-btn__machigai-sagashi " <> (if currentTab == MachigaiSagashiEditor then "is-active" else "")
          , HE.onClick \_ -> updateStore (S.UpdateView MachigaiSagashiEditor)
          ] []
      ]
