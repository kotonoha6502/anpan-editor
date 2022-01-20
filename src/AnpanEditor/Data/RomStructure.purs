module AnpanEditor.Data.RomStructure
  ( RomStructure
  , defaultRomStruct
  )
  where
  
type RomStructure =
  { chr ::
    { titleScreen ::
      { tilesAddr :: Int
      , layout1Addr :: Int
      , layout2Addr :: Int
      , paletteAddr :: Int
      }
    }
  }

defaultRomStruct :: RomStructure
defaultRomStruct = 
  { chr:
    { titleScreen:
      { tilesAddr: 0x0000
      , layout1Addr: 0x0000
      , layout2Addr: 0x0000
      , paletteAddr: 0x0000
      }
    }
  }