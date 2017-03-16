-- | 

module Renderer where

import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core
import Hyrule
import Control.Monad (void)
import Data.Foldable(toList)
import Data.List.Split (chunksOf, splitOn)

nextTerrain :: AreaType -> String -> String
nextTerrain Overworld "g" = "s"
nextTerrain Overworld "s" = "f"
nextTerrain Overworld "f" = "m"
nextTerrain Overworld "m" = "w"
nextTerrain Overworld "w" = "g"
nextTerrain (Dungeon _) "d" = "n"
nextTerrain (Dungeon _) "n" = "d"
nextTerrain _ _ = error "Wrong class"

tileToClass :: Tile -> String
tileToClass tile =
  case terrain tile of
    Grass -> "g"
    Sand -> "s"
    Forest -> "f"
    Mountain -> "m"
    Water -> "w"
    WDungeon -> "d"
    NWDungeon -> "n"
    --_ -> error "Terreno desconhecido"
    ++ " " ++
  case object tile of
    Pendant -> "P"
    MasterSword -> "S"
    Gate Overworld -> "O"
    Gate (Dungeon n) -> show n
    DummyGate -> "D"
    Home -> "H"
    Empty -> "_"
    --_ -> error "Objeto desconhecido"

classToTileData :: String -> (String, String)
classToTileData class' = let (t:o:_) = splitOn " " class' in (t,o)

saveMap :: AreaType ->  String -> IO ()
saveMap Overworld   m = writeFile "../maps/overworld.map" m
saveMap (Dungeon n) m | n >= 1 && n <= 3 = writeFile ("../maps/dungeon" ++ show n ++ ".map") m
                      | otherwise        = error "Mapa desconhecido"


setup :: [Area] ->  Window -> UI ()
setup areaList window = void $ do

  let (overworld:dungeon1:dungeon2:dungeon3:[]) = areaList

  -- Setup windows data
  return window # set UI.title "Area Editor"
  UI.addStyleSheet window "main.css"

  -- map modeled as a table
  owTable <- createTable overworld #. "show"
  d1Table <- createTable dungeon1 #. "hide"
  d2Table <- createTable dungeon2 #. "hide"
  d3Table <- createTable dungeon3 #. "hide"

  let tables = [owTable, d1Table, d2Table, d3Table]

  -- 
  overworldButton <- UI.button # set UI.text "Edit Overworld"
  dungeon1Button <- UI.button # set UI.text "Edit Dungeon 1"
  dungeon2Button <- UI.button # set UI.text "Edit Dungeon 2"
  dungeon3Button <- UI.button # set UI.text "Edit Dungeon 3"
  getBody window #+ [grid
                     [[row [element overworldButton, element dungeon1Button, element dungeon2Button, element dungeon3Button]],
                      [row [element owTable, element d1Table, element d2Table, element d3Table]]]]

  let buttons = [overworldButton, dungeon1Button, dungeon2Button, dungeon3Button]

  mapM_ (\t -> on UI.click (fst t) $ const $ do
            mapM_ (#. "hide") $ map element tables
            element (snd t) #. "show") $ zip buttons tables

    where
      createTable area = do
        let aSize = if areaType area == Overworld then 42 else 28

        table <- UI.table
        tdList <- mapM ( mapM (\tile -> let cn = tileToClass tile in  UI.td #. cn # set UI.value cn ) ) (chunksOf aSize . toList . areaModel $ area)
        trList <- mapM (\tds -> UI.tr #+ tds) $ map (map element) tdList
        saveButton <- UI.button # set UI.text "Save Alterations"

        mapM_ (mapM_ (\td -> on UI.click td $ const $ do
                   (terrain', object') <- classToTileData <$> get UI.value td
                   let cn = (nextTerrain (areaType area) terrain') ++ " " ++ object'
                   element td # set UI.value cn #. cn)) tdList

        on UI.click saveButton $ const $ do
          lst <- mapM (mapM (\c -> do
                                (t', o') <- classToTileData <$> get UI.value c
                                return $ t' ++ o')) tdList
          liftIO $ saveMap (areaType area) (concat . concat . map (++ ["\n"]) $ lst)
          return ()

        element table #+ map element trList
        column [element table, element saveButton]

boot :: [Area] -> IO ()
boot = startGUI defaultConfig {jsPort = Just 8088, jsStatic = Just "../wwwroot"} . setup
