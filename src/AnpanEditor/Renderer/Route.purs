module AnpanEditor.Renderer.Route where

import Prelude

import Data.Generic.Rep (class Generic)

data Route 
  = TitleEditor
  | MachigaiSagashiEditor

derive instance Eq Route
derive instance Ord Route
derive instance Generic Route _ 
