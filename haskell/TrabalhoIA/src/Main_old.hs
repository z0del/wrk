-- | Module Main embodies all modules, also have some helper functions to A*.

module Main where

import AStar
import Hyrule
import Renderer
import Parser
import Data.Array
import Data.Foldable (find)
import Data.List (nub)
import qualified Data.Map.Strict as Map
import Data.Maybe (fromJust)

findObject :: Object -> Area -> Maybe Position
findObject obj area = fst <$> find (\(_, t) -> object t == obj) (assocs (areaModel area))

findOverworldStartPosition :: Area -> Position
findOverworldStartPosition overworld  = fromJust . findObject Home $ overworld

findDungeonStartPosition :: Area -> Position
findDungeonStartPosition dungeon = fromJust . findObject (Gate $ Overworld) $ dungeon

overworldSize = 42
dungeonSize = 28

weight :: Terrain -> Weight
weight terr = Map.findWithDefault 10 terr $ Map.fromList [(Grass, 10),
                                                          (Sand, 20),
                                                          (Forest, 100),
                                                          (Mountain, 150),
                                                          (Water, 180),
                                                          (WDungeon, 10)]

walkable :: Area -> Position -> Bool
walkable area pos = terrain ((areaModel area) ! pos) /= NWDungeon

nextStepGen :: Area ->  Position -> [(Position, Weight)]
nextStepGen area pos@(a,b) = let area' = areaModel area
                                 w = weight . terrain $ area' ! pos
                             in map (\x -> (x, w)) $ nub [
  if a > 0 && walkable area (a - 1, b) then (a - 1, b) else (a, b) , -- walk to the left
  if a < (fst . snd . bounds $ (areaModel area)) && walkable area (a + 1, b) then (a + 1, b) else (a, b) , -- walk to the right
  if b > 0  && walkable area (a, b - 1) then (a, b - 1) else (a, b) , -- walk down
  if b < (snd . snd . bounds $ (areaModel area)) && walkable area (a, b + 1) then (a , b + 1) else (a, b)] -- walk up

reachedGoal :: Object -> Area  -> Position -> Bool
reachedGoal obj area  pos = object ((areaModel area) ! pos) == obj

reachedSword = reachedGoal MasterSword
reachedPendant = reachedGoal Pendant
reachedGate = reachedGoal . Gate . Dungeon

heuristic :: Area -> Position -> Weight
heuristic area pos =  weight . terrain $ ((areaModel area) ! pos)

-- map position from (y,x), zero-index to (x,y), one-idex
rearrangePosition :: Position -> Position
rearrangePosition (a,b) = (b + 1,a + 1)


main :: IO ()
main = do
  contentOverworld <- readFile "../maps/overworld.map"
  contentDungeon1  <- readFile "../maps/dungeon1.map"
  contentDungeon2  <- readFile "../maps/dungeon2.map"
  contentDungeon3  <- readFile "../maps/dungeon3.map"

  let overworldMap = parseMap Overworld overworldSize contentOverworld
      dungeon1Map  = parseMap (Dungeon 1) dungeonSize contentDungeon1
      dungeon2Map  = parseMap (Dungeon 2) dungeonSize contentDungeon2
      dungeon3Map  = parseMap (Dungeon 3) dungeonSize contentDungeon3
      overworldSP = findOverworldStartPosition overworldMap
      firstDungeonSP = findDungeonStartPosition dungeon1Map
      secondDungeonSP = findDungeonStartPosition dungeon2Map
      thirdDungeonSP = findDungeonStartPosition dungeon3Map

      totalCostAndPath = do
        (costFD, pathToFirstDungeon)  <- astarSearch overworldSP (reachedGate 1 overworldMap) (nextStepGen overworldMap) $ heuristic overworldMap
        (costFP, pathToFirstPendant)  <- astarSearch firstDungeonSP (reachedPendant dungeon1Map) (nextStepGen dungeon1Map) $ heuristic dungeon1Map
        (costSD, pathToSecondDungeon) <- astarSearch (last pathToFirstDungeon) (reachedGate 2 overworldMap) (nextStepGen overworldMap) $ heuristic overworldMap
        (costSP, pathToSecondPendant) <- astarSearch secondDungeonSP (reachedPendant dungeon2Map) (nextStepGen dungeon2Map) $ heuristic dungeon2Map
        (costTD, pathToThirdDungeon)  <- astarSearch (last pathToSecondDungeon) (reachedGate 3 overworldMap) (nextStepGen overworldMap) $ heuristic overworldMap
        (costTP, pathToThirdPendant)  <- astarSearch thirdDungeonSP (reachedPendant dungeon3Map) (nextStepGen dungeon3Map) $ heuristic dungeon3Map
        (costMS, pathToMasterSword)   <- astarSearch (last pathToThirdDungeon) (reachedSword overworldMap) (nextStepGen overworldMap) $ heuristic overworldMap
        let totalCost'  = [costFD, 2 * costFP, costSD,  2 * costSP, costTD,  2 * costTP, costMS]
            totalPath' = [Path Overworld pathToFirstDungeon,
                          Path (Dungeon 1) $ pathToFirstPendant ++ (tail . reverse $ pathToFirstPendant),
                          Path Overworld pathToSecondDungeon,
                          Path (Dungeon 2) $ pathToSecondPendant ++ (tail . reverse $ pathToSecondPendant),
                          Path Overworld pathToThirdDungeon,
                          Path (Dungeon 3) $ pathToThirdPendant ++ (tail .reverse $ pathToThirdPendant),
                          Path Overworld pathToMasterSword]
        return (totalCost', map (\(Path _ xs) -> (map rearrangePosition xs)) totalPath')

  boot [overworldMap, dungeon1Map, dungeon2Map, dungeon3Map]-- TODO: Implement link tracer
  let (totalCost', totalPath') = fromJust totalCostAndPath

  putStrLn $ "Custo para chegar a primeira dungeon: " ++ (show $ totalCost' !! 0)
  putChar '\n'
  putStrLn $ "Caminho a primeira dungeon:" ++ (show $ totalPath' !! 0)
  putChar '\n'
  putStrLn $ "Custo para chegar ao primeiro pingente: " ++ (show $ totalCost' !! 1)
  putChar '\n'
  putStrLn $ "Caminho ao primeiro pingente e volta:" ++ (show $ totalPath' !! 1)
  putChar '\n'
  putStrLn $ "Custo para chegar a segunda dungeon: " ++ (show $ totalCost' !! 2)
  putChar '\n'
  putStrLn $ "Caminho a segunda dungeon:" ++ (show $ totalPath' !! 2)
  putChar '\n'
  putStrLn $ "Custo para chegar ao segundo pingente e volta: " ++ (show $ totalCost' !! 3)
  putChar '\n'
  putStrLn $ "Caminho ao segundo pingente:" ++ (show $ totalPath' !! 3)
  putChar '\n'
  putStrLn $ "Custo para chegar a terceira dungeon: " ++ (show $ totalCost' !! 4)
  putChar '\n'
  putStrLn $ "Caminho a terceira dungeon:" ++ (show $ totalPath' !! 4)
  putChar '\n'
  putStrLn $ "Custo para chegar ao terceiro pingente e volta: " ++ (show $ totalCost' !! 5)
  putChar '\n'
  putStrLn $ "Caminho ao terceiro pingente:" ++ (show $ totalPath' !! 5)
  putChar '\n'
  putStrLn $ "Custo para chegar a MasterSword: " ++ (show $ totalCost' !! 6)
  putChar '\n'
  putStrLn $ "Caminho a MasterSword :" ++ (show $ totalPath' !! 6)
  putChar '\n'
  putStrLn $ "Custo total: " ++ (show . sum $ totalCost')
  putChar '\n'
