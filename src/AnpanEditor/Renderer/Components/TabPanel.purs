module AnpanEditor.Renderer.Components.TabPanel
  ( tabPanel
  )
  where

import Prelude

import Halogen (ClassName(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.Hooks as Hooks

type InputType tab m =
  { value :: tab
  , render :: tab -> H.ComponentHTML (Hooks.HookM m Unit) () m
  }

tabPanel :: forall q o m tab. H.Component q (InputType tab m) o m
tabPanel = Hooks.component \_ { value, render } -> Hooks.do
  Hooks.pure do
    HH.div [ HP.class_ $ ClassName "tab-panel" ]
      [ render value ]