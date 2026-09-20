import java.util.*;
import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        Map<String, Integer> wordCount = new HashMap<>();

        // Read from stdin
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line;
        while ((line = reader.readLine()) != null) {
            // Extract words (maximal runs of ASCII letters)
            int i = 0;
            while (i < line.length()) {
                char c = line.charAt(i);
                // Check if character is an ASCII letter (a-z or A-Z)
                if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
                    StringBuilder word = new StringBuilder();
                    // Collect all consecutive ASCII letters
                    while (i < line.length()) {
                        char ch = line.charAt(i);
                        if ((ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')) {
                            word.append(ch);
                            i++;
                        } else {
                            break;
                        }
                    }
                    // Convert to lowercase and count
                    String wordStr = word.toString().toLowerCase();
                    wordCount.put(wordStr, wordCount.getOrDefault(wordStr, 0) + 1);
                } else {
                    i++;
                }
            }
        }

        // Sort by count descending, then by word ascending
        List<Map.Entry<String, Integer>> entries = new ArrayList<>(wordCount.entrySet());
        entries.sort((a, b) -> {
            // First compare by count (descending)
            if (!a.getValue().equals(b.getValue())) {
                return b.getValue().compareTo(a.getValue());
            }
            // Then compare by word (ascending)
            return a.getKey().compareTo(b.getKey());
        });

        // Output
        for (Map.Entry<String, Integer> entry : entries) {
            System.out.println(entry.getKey() + " " + entry.getValue());
        }
    }
}
