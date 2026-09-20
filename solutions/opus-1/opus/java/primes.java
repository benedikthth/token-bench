import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder in = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) in.append(line).append(' ');
        String s = in.toString().trim();
        int n = s.isEmpty() ? 0 : Integer.parseInt(s.split("\\s+")[0]);
        StringBuilder sb = new StringBuilder();
        if (n >= 2) {
            boolean[] composite = new boolean[n + 1];
            for (int i = 2; (long) i * i <= n; i++) {
                if (!composite[i]) {
                    for (int j = i * i; j <= n; j += i) composite[j] = true;
                }
            }
            for (int i = 2; i <= n; i++) {
                if (!composite[i]) {
                    if (sb.length() > 0) sb.append(' ');
                    sb.append(i);
                }
            }
        }
        sb.append('\n');
        PrintWriter out = new PrintWriter(new BufferedWriter(new OutputStreamWriter(System.out)));
        out.print(sb);
        out.flush();
    }
}
