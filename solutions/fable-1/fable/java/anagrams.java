import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        Map<String, List<String>> groups = new HashMap<>();
        String line;
        while ((line = in.readLine()) != null) {
            String word = line.trim();
            if (word.isEmpty()) continue;
            char[] chars = word.toCharArray();
            Arrays.sort(chars);
            String key = new String(chars);
            groups.computeIfAbsent(key, k -> new ArrayList<>()).add(word);
        }
        List<List<String>> result = new ArrayList<>(groups.values());
        for (List<String> g : result) Collections.sort(g);
        result.sort((a, b) -> a.get(0).compareTo(b.get(0)));
        PrintWriter out = new PrintWriter(System.out);
        for (List<String> g : result) {
            out.println(String.join(" ", g));
        }
        out.flush();
    }
}
