module AnpanEditor.Data.Config
  ( Config
  )
  where

import AnpanEditor.Data.RomStructure (RomStructure)

type Config =
  { romStructure :: RomStructure
  }