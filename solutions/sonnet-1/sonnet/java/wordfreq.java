import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder sb = new StringBuilder();
        int ch;
        while ((ch = reader.read()) != -1) {
            sb.append((char) ch);
        }
        String text = sb.toString();

        Map<String, Integer> counts = new HashMap<>();
        int i = 0;
        int n = text.length();
        while (i < n) {
            char c = text.charAt(i);
            if (Character.isLetter(c) && c < 128) {
                int start = i;
                while (i < n && Character.isLetter(text.charAt(i)) && text.charAt(i) < 128) {
                    i++;
                }
                String word = text.substring(start, i).toLowerCase();
                counts.merge(word, 1, Integer::sum);
            } else {
                i++;
            }
        }

        List<Map.Entry<String, Integer>> entries = new ArrayList<>(counts.entrySet());
        entries.sort((a, b) -> {
            int cmp = b.getValue() - a.getValue();
            if (cmp != 0) return cmp;
            return a.getKey().compareTo(b.getKey());
        });

        StringBuilder out = new StringBuilder();
        for (Map.Entry<String, Integer> e : entries) {
            out.append(e.getKey()).append(' ').append(e.getValue()).append('\n');
        }
        System.out.print(out);
    }
}
