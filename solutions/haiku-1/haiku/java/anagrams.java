import java.util.*;
import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line;

        // Map to group words by their sorted letters (canonical form)
        Map<String, List<String>> anagramGroups = new TreeMap<>();

        while ((line = br.readLine()) != null) {
            String word = line.trim();
            if (word.isEmpty()) continue;

            // Create canonical form by sorting letters
            char[] chars = word.toCharArray();
            Arrays.sort(chars);
            String canonical = new String(chars);

            // Add word to its group
            anagramGroups.putIfAbsent(canonical, new ArrayList<>());
            anagramGroups.get(canonical).add(word);
        }

        // Create list of groups and sort by first word
        List<List<String>> groups = new ArrayList<>();
        for (List<String> group : anagramGroups.values()) {
            Collections.sort(group);
            groups.add(group);
        }

        // Sort groups by their first word
        groups.sort((a, b) -> a.get(0).compareTo(b.get(0)));

        // Output
        for (List<String> group : groups) {
            System.out.println(String.join(" ", group));
        }
    }
}
