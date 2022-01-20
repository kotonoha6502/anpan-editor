module Main where

import Prelude

import AnpanEditor.Data.RomStructure (defaultRomStruct)
import AnpanEditor.Renderer.App (app)
import AnpanEditor.Renderer.Monad (runAppM)
import AnpanEditor.Renderer.Route (Route(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Halogen.Aff (awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = do
  runHalogenAff do
    body <- awaitBody

    let
      initialStore =
        { currentView: TitleEditor
        , romImage: Nothing
        , config:
          { romStructure: defaultRomStruct
          }
        }
    
    rootComponent <- runAppM initialStore app
    runUI rootComponent {} body
