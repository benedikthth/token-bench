import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String a = br.readLine();
        String b = br.readLine();
        a = a == null ? "" : a.trim();
        b = b == null ? "" : b.trim();
        int m = b.length();
        int[] prev = new int[m + 1];
        int[] cur = new int[m + 1];
        for (int i = 0; i < a.length(); i++) {
            char c = a.charAt(i);
            cur[0] = 0;
            for (int j = 1; j <= m; j++) {
                if (c == b.charAt(j - 1)) cur[j] = prev[j - 1] + 1;
                else cur[j] = Math.max(prev[j], cur[j - 1]);
            }
            int[] t = prev; prev = cur; cur = t;
        }
        System.out.println(prev[m]);
    }
}
