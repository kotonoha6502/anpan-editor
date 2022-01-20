module AnpanEditor.Renderer.Components.Tabs where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Halogen (ClassName(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.Hooks (useQuery, useState)
import Halogen.Hooks as Hooks
import Type.Proxy (Proxy(..))

type Tab t = { value :: t, label :: String } 

type Tabs t = Array (Tab t)

type InputType t = 
  { tabs :: Tabs t
  , initial :: t
  }

data MessageType t = TabChanged t

data QueryType t a
  = CurrentTab (t -> a)
  | SetTab t a

data Action t
  = TabClicked t

_tab :: Proxy "tab"
_tab = Proxy

tabs :: forall m tab. Eq tab => H.Component (QueryType tab) (InputType tab) (MessageType tab) m
tabs = Hooks.component \{ queryToken, outputToken } { tabs: tabList, initial } -> Hooks.do
  currentTab /\ currentTabId <- useState initial

  let
    handleAction :: Action tab -> Hooks.HookM _ _
    handleAction = case _ of
      TabClicked tab -> do
        when (currentTab /= tab) do
          Hooks.raise outputToken $ TabChanged tab 
        Hooks.put currentTabId tab

  useQuery queryToken case _ of
    CurrentTab reply -> pure (Just $ reply currentTab)
    SetTab tab a -> do
      handleAction (TabClicked tab)
      pure (Just a)

  Hooks.pure do
    HH.div [ HP.class_ $ ClassName "tabs" ]
      [ HH.ul [ HP.class_ $ ClassName "tab-list" ]
        (tabList <#> \{ value, label } -> 
          let
            tabClass = "tab "
              <> (if value == currentTab then "is-active " else "")
          in
            HH.li
              [ HP.class_ $ ClassName tabClass
              , HE.onClick \_ -> handleAction (TabClicked value)
              ]
              [ HH.text label ]
        )      
      ]
