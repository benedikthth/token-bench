import java.io.BufferedReader;
import java.io.InputStreamReader;

public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        String line = br.readLine();
        if (line == null) line = "";

        StringBuilder out = new StringBuilder();
        int n = line.length();
        int i = 0;
        while (i < n) {
            char c = line.charAt(i);
            int j = i;
            while (j < n && line.charAt(j) == c) j++;
            out.append(c).append(j - i);
            i = j;
        }

        System.out.println(out.toString());
    }
}
