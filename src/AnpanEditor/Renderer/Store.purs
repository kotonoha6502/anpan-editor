module AnpanEditor.Renderer.Store
  ( Action(..)
  , Store
  , reducer
  , selectCurrentView
  )
  where


import AnpanEditor.Renderer.Route (Route)
import Halogen.Store.Select (Selector, selectEq)

type Store =
  { currentView :: Route
  }


selectCurrentView :: Selector Store Route
selectCurrentView = selectEq \store -> store.currentView

data Action
  = UpdateView Route

reducer :: Store -> Action -> Store
reducer currentStore = case _ of
  UpdateView to -> currentStore { currentView = to }