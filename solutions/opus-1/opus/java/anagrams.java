import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        Map<String, List<String>> groups = new HashMap<>();
        String line;
        while ((line = in.readLine()) != null) {
            String w = line.trim();
            if (w.isEmpty()) continue;
            char[] c = w.toCharArray();
            Arrays.sort(c);
            groups.computeIfAbsent(new String(c), k -> new ArrayList<>()).add(w);
        }
        List<List<String>> list = new ArrayList<>(groups.values());
        for (List<String> g : list) Collections.sort(g);
        list.sort((a, b) -> a.get(0).compareTo(b.get(0)));
        StringBuilder sb = new StringBuilder();
        for (List<String> g : list) sb.append(String.join(" ", g)).append('\n');
        System.out.print(sb);
    }
}
