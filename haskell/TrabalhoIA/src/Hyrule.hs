-- | Module Hyrule describes the whole Kingdom of Hyrule as DataTypes and Type aliases

module Hyrule where

import Data.Array

-- Map

data Tile = Tile { terrain :: Terrain, object :: Object} deriving (Show)

data Terrain = Grass | Sand | Forest | Mountain | Water | WDungeon | NWDungeon deriving (Eq, Ord, Show, Read)

data Object = Pendant | MasterSword | Gate AreaType | DummyGate | Home | Empty deriving (Eq, Show, Read)

data AreaType = Dungeon Int | Overworld deriving (Eq, Show, Read)

data Path = Path AreaType [Position] deriving Show

-- Model

type Weight = Int

type Position = (Int, Int)

data Area = Area { areaType :: AreaType, areaModel :: Array Position Tile }

type AreaSize = Int
