module Lab1 where      

import Prelude hiding (lookup, readFile, getContents)
import System.Environment (getArgs)
import System.IO.UTF8 (readFile, getContents)
import Data.Char (isAlpha, toLower, isPunctuation)
import Data.HashTable
import Data.Maybe (fromMaybe)
import Data.Function (on)
import Data.List (sortBy, dropWhileEnd)
import Data.Foldable (foldlM)

type Frequencies = HashTable String Int

-- Get relevant words according to the instructions in the assignment.
-- Convert to lowercase, keep the single quotes ("Don't" -> "don't")
getWords :: String -> [String]
getWords str = let
  isGoodChar c = isAlpha c || c `elem` "`'"
  chunk s = let (word, notGood) = span isGoodChar s
                (_, rest) = break isGoodChar notGood 
            in word : (if null rest then [] else chunk rest)
  trim = dropWhile isPunctuation . dropWhileEnd isPunctuation
  lower = map toLower str
  in [trimmed | word <- chunk lower, let trimmed = trim word, trimmed /= ""]

emptyFrequencies :: IO Frequencies
emptyFrequencies = fromList hashString []

increaseCount :: Frequencies -> String -> IO Frequencies
increaseCount frequencies word = do
  maybeCount <- lookup frequencies word
  let count = fromMaybe 0 maybeCount
  _ <- update frequencies word (count + 1)
  return frequencies

countWords :: Frequencies -> String -> IO Frequencies
countWords frequencies str =
  foldlM increaseCount frequencies (getWords str)

-- read list files from arguments or use stdin
processInputs :: IO Frequencies
processInputs = do
  frequencies <- emptyFrequencies
  args <- getArgs
  contents <- if null args
                then sequence [getContents]
                else mapM readFile args
  foldlM countWords frequencies contents

printFrequencies :: IO ()
printFrequencies = do
  frequencies <- processInputs
  list <- toList frequencies
  let sorted = sortBy (compare `on` negate . snd) list
      maxLengthWord = maximum $ map (length . fst) sorted
      maxLengthBar = 80 - maxLengthWord - 1
      maxCount = (snd . head) sorted
      baseUnit = fromIntegral maxLengthBar / fromIntegral maxCount :: Double
      makeBar count = replicate (round $ fromIntegral count * baseUnit) '#'
      pad w = take (maxLengthWord + 1) (w ++ cycle " ")
      bars = [pad w ++ bar | (w, count) <- sorted, let bar = makeBar count, bar /= ""]
  mapM_ putStrLn bars


