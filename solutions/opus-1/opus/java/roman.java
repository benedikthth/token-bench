import java.io.*;

public class Main {
    public static void main(String[] args) throws IOException {
        int[] v = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
        String[] s = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringBuilder out = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            line = line.trim();
            if (line.isEmpty()) continue;
            int n = Integer.parseInt(line);
            for (int i = 0; i < v.length; i++) {
                while (n >= v[i]) {
                    out.append(s[i]);
                    n -= v[i];
                }
            }
            out.append('\n');
        }
        System.out.print(out);
    }
}
