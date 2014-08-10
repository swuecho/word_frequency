import Data.List
import Data.Char
import qualified Data.Map as M      
## to lower case and to array
my @words = split(/\W+/, lc($buffer));
--split in to words
cleanToWords = M.fromList . words . map (\c -> if isAlpha c then toLower c else ' ')



## to hash
my %words_dic;
foreach (@words) {
    $words_dic{$_}++;
}


## sort and  write
open my $fh_out, '>', $ARGV[1];

foreach ( sort { $words_dic{$a} <=> $words_dic{$b} || $a cmp $b} ( keys %words_dic ) ) {
    say $fh_out "$words_dic{$_}, $_";
}

close $fh_out;

----
-- Stephen Mann
-- February 2010
--
-- Haskell answer to word-counting challenge
--
-- Compile with:
--  ghc word.hs -o word
--
-- Run with:
--  time word < sampleFile.txt > output.txt
--

main = interact                          -- IO
  $ unlines                              -- combine meta-data into string
  . map (\(n, w) -> show n ++ ", " ++ w) -- pretty print
  . sort                                 -- sort meta-data by occurances
  . map (\s -> (length s, head s))       -- transform to sublist meta-data
  . group                                -- break into sublists of unique words
  . sort                                 -- sort words
  . words                                -- break into words
  . map (\c ->                           -- simplify chars in input
    if isAlpha c
      then toLower c
      else ' ')
