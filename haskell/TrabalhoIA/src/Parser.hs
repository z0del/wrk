-- | Module Parser transforms text files in a Tiles array (strongly typed).

module Parser where

import Hyrule
import Data.Array
import Text.Trifecta
import Control.Applicative ((<|>))
data TerrainError = TerrainError
data ObjectError = ObjectError


parseTerrain :: AreaType -> Parser Terrain
parseTerrain Overworld = do
  terrain' <- letter
  case terrain' of
    'g' -> return Grass
    's' -> return Sand
    'f' -> return Forest
    'm' -> return Mountain
    'w' -> return Water
    _   -> fail "Terreno desconhecido"

parseTerrain (Dungeon _) = do
  terrain' <- letter
  case terrain' of
    'd' -> return WDungeon
    'n' -> return NWDungeon
    _  -> fail "Terreno desconhecido"

parseObject :: AreaType -> Parser Object
parseObject Overworld = do
  object' <- letter <|> digit <|> char '_'
  case object' of
    'S' -> return MasterSword
    '_' -> return Empty
    'H' -> return Home
    'D' -> return DummyGate
    '1' -> return . Gate $ Dungeon 1
    '2' -> return . Gate $ Dungeon 2
    '3' -> return . Gate $ Dungeon 3
    _   -> fail "Objeto desconhecido"

parseObject (Dungeon _) = do
  object' <- letter <|> char '_'
  case object' of
    'P' -> return Pendant
    'O' -> return . Gate $ Overworld
    '_' -> return Empty
    _   -> fail "Objeto desconhecido"

parseTiles :: AreaType -> AreaSize -> Parser (Array Position Tile)
parseTiles areaType' areaSize = do

  rows <- some parseLine
  if length rows == areaSize
    then return $ listArray ((0,0), (areaSize - 1, areaSize - 1)) $ concat rows
    else fail $ "O mapa deve possuir " ++ show areaSize ++ " linhas"

  where
    parseLine = do
      tiles  <- some parseTile
      newline
      let row = tiles
      if length row == areaSize
        then return row <?> "Row of Tiles"
        else fail $ "O mapa deve possuir " ++ show areaSize ++ " colunas"

    parseTile = do
      terrain' <- parseTerrain areaType'
      object'  <- parseObject areaType'
      (return $ Tile terrain' object') <?> "Tile"

parseMap :: AreaType -> AreaSize ->  String -> Area
parseMap areaType' areaSize str = extract $ parseString (parseTiles areaType' areaSize) mempty str
  where
    extract (Success p) = Area areaType' p
    extract (Failure e) = error $  "Nao foi possível realizar o parser do mapa. Erro: " ++ show e
