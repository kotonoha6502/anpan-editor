module AnpanEditor.Renderer.Views.MachigaiSagashiView where

import Halogen as H
import Halogen.HTML as HH
import Halogen.Hooks as Hooks

machigaiSagashiView :: forall q i o m. H.Component q i o m
machigaiSagashiView = Hooks.component \_ _ -> Hooks.do
  Hooks.pure do
    HH.text "まちがいさがしえでぃた〜"