import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

class ValueComparator implements Comparator<String> {

    Map<String, Integer> base;
    public ValueComparator(Map<String, Integer> base) {
        this.base = base;
    }

    // Note: this comparator imposes orderings that are inconsistent with equals.    
    public int compare(String a, String b) {
        if (base.get(a) > base.get(b)) {
            return 1;
        } else if (base.get(a) < base.get(b)){
            return -1;
        } else {
        	return (a.compareTo(b)) ;
        	
        }
    }
}


public class CountWord {

	public static void main(String[] args) throws IOException {
		
		String fileName = "/Users/hwu/dev/count-word-frequencies/big.txt";
		//create a new HashMap
	    Map<String, Integer> frequencyMap = new HashMap<String, Integer>(); 
	    ValueComparator bvc =  new ValueComparator(frequencyMap);
	    // read all lines from file
		// Note: java io is crazy
		List<String> lines = Files.readAllLines(Paths.get(fileName), Charset.forName("UTF-8"));
		
		// put the word in to HashMap
		for (String line: lines) {
			// split line to words and then add to HashMap
			String[] words= line.split("\\W+");
			for (String word: words) {
				if (word.matches("[a-z]+")) {
				// This is the core of put word in HashMap
				if (frequencyMap.containsKey(word)) {
					// if the word exist in HashMap, get the original value and plus 1
					frequencyMap.put(word, frequencyMap.get(word) + 1);
				} else {
					// if not exists already, put 1
					frequencyMap.put(word, 1);
				}
				}
			}
		}
		
		TreeMap<String,Integer> sorted_map = new TreeMap<String,Integer>(bvc);
		sorted_map.putAll(frequencyMap);
		// set up output
		PrintWriter writer = new PrintWriter("/Users/hwu/dev/count-word-frequencies/output_java.txt", "UTF-8");
		
		for(Map.Entry<String,Integer> entry : sorted_map.entrySet()) {
			  String key = entry.getKey();
			  Integer value = entry.getValue();
			  writer.println(value + " : " + key);
			}
		writer.close();
	}

}
