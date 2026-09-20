import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        Map<String, List<String>> groups = new HashMap<>();
        String line;
        while ((line = br.readLine()) != null) {
            String word = line.trim();
            if (word.isEmpty()) continue;
            char[] chars = word.toCharArray();
            java.util.Arrays.sort(chars);
            String key = new String(chars);
            groups.computeIfAbsent(key, k -> new ArrayList<>()).add(word);
        }

        List<List<String>> result = new ArrayList<>();
        for (List<String> g : groups.values()) {
            Collections.sort(g);
            result.add(g);
        }
        result.sort((a, b) -> a.get(0).compareTo(b.get(0)));

        StringBuilder sb = new StringBuilder();
        for (List<String> g : result) {
            sb.append(String.join(" ", g)).append("\n");
        }
        System.out.print(sb);
    }
}
