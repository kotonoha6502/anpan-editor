module AnpanEditor.Renderer.App
  ( app
  )
  where

import Prelude

import AnpanEditor.Data.NES.VirtualROM (VROM)
import AnpanEditor.Electron.ExposedAPI (onRomFileSelected)
import AnpanEditor.Electron.ExposedAPI as Electron
import AnpanEditor.Renderer.Components.SideMenu (sideMenu)
import AnpanEditor.Renderer.Route (Route(..))
import AnpanEditor.Renderer.Store as S
import Data.Maybe (Maybe(..), fromMaybe)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (class MonadEffect)
import Halogen (ClassName(..), liftEffect)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks (useLifecycleEffect)
import Halogen.Hooks as Hooks
import Halogen.Store.Monad (class MonadStore, updateStore)
import Halogen.Store.Select (Selector, select)
import Halogen.Store.UseSelector (useSelector)
import Halogen.Subscription (Emitter)
import Halogen.Subscription as HS
import Type.Proxy (Proxy(..))

data Action
  = RomFileSelected VROM

type Context = 
  { currentView :: Route
  , romImage :: Maybe VROM
  }

_sideMenu :: Proxy "sideMenu"
_sideMenu = Proxy

-- _routerView :: Proxy "routerView"
-- _routerView = Proxy

selector :: Selector S.Store Context
selector = select
  (\bef aft -> bef.currentView == aft.currentView)
  (\store -> { currentView: store.currentView, romImage: store.romImage })

app :: forall q i o m
     . MonadEffect m
    => MonadStore S.Action S.Store m
    => H.Component q i o m
app = Hooks.component \_ _ -> Hooks.do
  ctx <- useSelector selector
  
  useLifecycleEffect do
    emitter <- liftEffect subscribeToRomFileSelected
    subscriptionId <- Hooks.subscribe $ map (handleAction ctx) emitter
    pure $ Just $ Hooks.unsubscribe subscriptionId

  Hooks.pure do
    let currentTab = fromMaybe TitleEditor (_.currentView <$> ctx)
    HH.div [HP.id "app"]
      [ HH.div [HP.class_ $ ClassName "main-layout is-flex" ]
        [ HH.div [HP.class_ $ ClassName "side-view-container"]
          [ HH.slot _sideMenu unit sideMenu {} absurd ]
        , HH.div [HP.class_ $ ClassName "router-view-container"]
          [ renderRouterView currentTab ]
        ]
      ]
  where
    renderRouterView :: Route -> _
    renderRouterView = case _ of
      TitleEditor -> HH.text "たいとるえでぃた〜"
      MachigaiSagashiEditor -> HH.text "まちがいさがしえでぃた〜"

    handleAction :: Maybe Context -> Action -> Hooks.HookM m Unit
    handleAction _ = case _ of
      RomFileSelected vrom -> do
        updateStore (S.SetRomImage vrom)

    subscribeToRomFileSelected :: Effect (Emitter Action)
    subscribeToRomFileSelected = do
      { emitter, listener } <- HS.create
      onRomFileSelected \path -> launchAff_ $ do
        vrom <- Electron.loadRomFile path
        liftEffect $ HS.notify listener (RomFileSelected vrom)
      pure emitter
