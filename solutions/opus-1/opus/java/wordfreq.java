import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        byte[] data = System.in.readAllBytes();
        Map<String, Integer> counts = new HashMap<>();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i <= data.length; i++) {
            int c = i < data.length ? data[i] : -1;
            if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z')) {
                sb.append((char) (c | 0x20));
            } else if (sb.length() > 0) {
                counts.merge(sb.toString(), 1, Integer::sum);
                sb.setLength(0);
            }
        }
        List<Map.Entry<String, Integer>> list = new ArrayList<>(counts.entrySet());
        list.sort((a, b) -> {
            int d = Integer.compare(b.getValue(), a.getValue());
            return d != 0 ? d : a.getKey().compareTo(b.getKey());
        });
        StringBuilder out = new StringBuilder();
        for (Map.Entry<String, Integer> e : list) {
            out.append(e.getKey()).append(' ').append(e.getValue()).append('\n');
        }
        System.out.print(out);
    }
}
