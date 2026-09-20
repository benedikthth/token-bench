import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws IOException {
        InputStream in = new BufferedInputStream(System.in, 1 << 16);
        Map<String, Integer> counts = new HashMap<>();
        StringBuilder cur = new StringBuilder();
        byte[] buf = new byte[1 << 16];
        int n;
        while ((n = in.read(buf)) > 0) {
            for (int i = 0; i < n; i++) {
                int c = buf[i] & 0xff;
                if ((c >= 'a' && c <= 'z')) {
                    cur.append((char) c);
                } else if (c >= 'A' && c <= 'Z') {
                    cur.append((char) (c + 32));
                } else if (cur.length() > 0) {
                    counts.merge(cur.toString(), 1, Integer::sum);
                    cur.setLength(0);
                }
            }
        }
        if (cur.length() > 0) {
            counts.merge(cur.toString(), 1, Integer::sum);
        }
        List<Map.Entry<String, Integer>> entries = new ArrayList<>(counts.entrySet());
        entries.sort((a, b) -> {
            int c = Integer.compare(b.getValue(), a.getValue());
            if (c != 0) return c;
            return a.getKey().compareTo(b.getKey());
        });
        StringBuilder out = new StringBuilder();
        for (Map.Entry<String, Integer> e : entries) {
            out.append(e.getKey()).append(' ').append(e.getValue()).append('\n');
        }
        PrintStream ps = new PrintStream(new FileOutputStream(FileDescriptor.out), false);
        ps.print(out);
        ps.flush();
    }
}
