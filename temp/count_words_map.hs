import Data.List
import Data.Char
import qualified Data.Map as Map

--split in to words
wordList str = map (\word -> (word, 1)) $ words  $ map (\c -> if isAlpha c then toLower c else ' ') str 

wordListToMap :: (Ord k) => [(k, Int)] -> Map.Map k Int 
wordListToMap xs = Map.fromListWith (\number1 number2 -> number1 +  number2) xs 

compareTuple::(String, Int)-> (String, Int) ->Ordering
compareTuple (a,b) (c,d) 
    | b < d = LT
    | otherwise = GT


main = interact     
  $ unlines                              -- combine meta-data into string
  . map (\(w, c) -> w ++ ": " ++ show c) -- pretty print
  . sortBy compareTuple
  . Map.toList                           
  . wordListToMap     
  . wordList         
