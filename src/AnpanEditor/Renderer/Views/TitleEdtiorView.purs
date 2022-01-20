module AnpanEditor.Renderer.Views.TitleEditorView where

import Prelude

import AnpanEditor.Renderer.Components.TabPanel (tabPanel)
import AnpanEditor.Renderer.Components.Tabs (MessageType(..), Tabs, tabs) as T
import AnpanEditor.Renderer.Store as St
import Data.Tuple.Nested ((/\))
import Halogen (ClassName(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks (useState)
import Halogen.Hooks as Hooks
import Halogen.Store.Monad (class MonadStore)
import Type.Proxy (Proxy(..))

data Tab = Layout | TileAndPalette
derive instance Eq Tab

tabToLabel :: Tab -> String
tabToLabel = case _ of
  Layout -> "レイアウト"
  TileAndPalette -> "タイル＆パレット"


tabs :: T.Tabs Tab
tabs = 
  [ { value: Layout, label: tabToLabel Layout }
  , { value: TileAndPalette, label: tabToLabel TileAndPalette }
  ]

titleEditorView :: forall q i o m
                .  MonadStore St.Action St.Store m
                => H.Component q i o m
titleEditorView = Hooks.component \_ _ -> Hooks.do
  currentTab /\ currentTabId <- useState Layout

  let
    handleTabsMessage :: T.MessageType Tab -> Hooks.HookM m Unit
    handleTabsMessage = case _ of
      T.TabChanged to -> do
        when (to /= currentTab) do
          Hooks.put currentTabId to

  Hooks.pure do
    HH.div [HP.class_ $ ClassName "title-editor-view"]
      [ HH.slot (Proxy :: Proxy "tabs") unit T.tabs { tabs, initial: currentTab } handleTabsMessage
      , HH.div [ HP.class_ $ ClassName "tab-panel-container" ]
        [ HH.slot_ (Proxy :: Proxy "tabPanel") unit tabPanel { value: currentTab, render: renderTabPanel }
        ]
      ]

  where

  renderTabPanel :: Tab -> H.ComponentHTML _ _ _  
  renderTabPanel = case _ of
    Layout -> HH.text "レイアウト"

    TileAndPalette -> do
      HH.div [ HP.class_ $ ClassName "title-editor__tail-and-palette" ]
        [ HH.canvas
          [ HP.id "chr-pattern"
          , HP.width 256
          , HP.height 256
          ]
        ]
