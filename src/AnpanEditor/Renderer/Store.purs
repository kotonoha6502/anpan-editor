module AnpanEditor.Renderer.Store
  ( Action(..)
  , Store
  , reducer
  , selectCurrentView
  )
  where


import AnpanEditor.Data.Config (Config)
import AnpanEditor.Data.NES.VirtualROM (VROM)
import AnpanEditor.Renderer.Route (Route)
import Data.Maybe (Maybe(..))
import Halogen.Store.Select (Selector, selectEq)

type Store =
  { currentView :: Route
  , romImage :: Maybe VROM
  , config :: Config
  }

selectCurrentView :: Selector Store Route
selectCurrentView = selectEq \store -> store.currentView

data Action
  = UpdateView Route
  | SetRomImage VROM

reducer :: Store -> Action -> Store
reducer currentStore = case _ of
  UpdateView to -> currentStore { currentView = to }
  SetRomImage vrom -> currentStore { romImage = Just vrom }
