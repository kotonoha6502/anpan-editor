module AnpanEditor.Renderer.App
  ( app
  )
  where

import Prelude

import AnpanEditor.Renderer.Components.SideMenu (sideMenu)
import AnpanEditor.Renderer.Route (Route(..))
import AnpanEditor.Renderer.Store (selectCurrentView)
import AnpanEditor.Renderer.Store as S
import Data.Maybe (Maybe(..), fromMaybe)
import Halogen (ClassName(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks
import Halogen.Store.Monad (class MonadStore)
import Halogen.Store.UseSelector (useSelector)
import Type.Proxy (Proxy(..))
import Web.Event.Event (Event)

data Action = Input Event | Click

_sideMenu :: Proxy "sideMenu"
_sideMenu = Proxy

-- _routerView :: Proxy "routerView"
-- _routerView = Proxy

app :: forall q i o m
     . MonadStore S.Action S.Store m
    => H.Component q i o m
app = Hooks.component \_ _ -> Hooks.do
  ctx <- useSelector selectCurrentView

  Hooks.pure do
    let currentTab = fromMaybe TitleEditor ctx
    HH.div [HP.id "app"]
      [ HH.div [HP.class_ $ ClassName "main-layout is-flex" ]
        [ HH.div [HP.class_ $ ClassName "side-view-container"]
          [ HH.slot _sideMenu unit sideMenu {} absurd
          ]
        , HH.div [HP.class_ $ ClassName "router-view-container"]
          [ renderRouterView currentTab ]
        ]
      ]
  where
    renderRouterView :: Route -> _
    renderRouterView = case _ of
      TitleEditor -> HH.text "たいとるえでぃた〜"
      MachigaiSagashiEditor -> HH.text "まちがいさがしえでぃた〜"