module AnpanEditor.Data.NES.PPU where


type Tile =
  { palette :: Int
  , pattern ::
    { lt :: Int -- left top
    , rt :: Int -- right top
    , lb :: Int -- left bottom
    , rb :: Int -- right bottom
    }
  }
