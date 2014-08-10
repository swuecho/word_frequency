import std.stdio, std.string, std.algorithm;
/*
The problem is, line has type char[] and the map's key type is string, 
i.s. array of immutable char. To convert x to string you need to say 
either x.idup or to!string(x). In theory the compiler/library would be 
clever enough to do that automatically when necessary, but we decided 
against it for now.

So: replace dictionary[word] with either dictionary[word.idup] or 
dictionary[to!string(word)]. A future printing will correct this mistake.
*/

void main() {
  // compute counts
  uint[string] freqs;
  foreach (line; stdin.byLine) {
    foreach (word; splitter(strip(line))) {
      ++freqs[word.idup];
    }
  }
string[] words = freqs.keys;
sort! ((a, b) { return freqs[a] > freqs[b]; }) (words) ;
  // print counts
  foreach (word; words) {
    writefln("%6u\t%s", freqs[word], word);
  }
}
