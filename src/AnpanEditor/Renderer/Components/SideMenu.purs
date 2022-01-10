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
      [ sideMenuItem TitleEditor (currentTab == TitleEditor)
      , sideMenuItem MachigaiSagashiEditor (currentTab == MachigaiSagashiEditor)
      ]

sideMenuItem :: forall m
             .  MonadStore S.Action S.Store m
             => Route
             -> Boolean
             -> H.ComponentHTML (Hooks.HookM m Unit) () m
sideMenuItem tab active =
  let
    btnClass = case tab of
      TitleEditor -> "title"
      MachigaiSagashiEditor -> "machigai-sagashi"

    containerClass = "side-menu-item-container is-position-relative is-flex is-justify-content-center "
      <> (if active then "is-active" else "")

    innerClass = "side-menu-btn is-square-32 "
      <> "side-menu-btn__" <> btnClass <> " "
      <> (if active then "is-active " else "")

    maskClass = "side-menu-item__mask is-position-absolute is-square-32 "
      <> (if active then "is-transparent " else "")

  in 

    HH.div [ HP.class_ $ ClassName containerClass ]
      [ HH.div [ HP.class_ $ ClassName "side-menu-item" ]
        [ HH.div
          [ HP.class_ $ ClassName innerClass
          , HE.onClick \_ -> updateStore (S.UpdateView tab)
          ] []
        ]
      , HH.div
        [ HP.class_ $ ClassName maskClass
        ] []
      ]