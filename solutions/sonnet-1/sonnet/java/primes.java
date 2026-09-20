import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int n = scanner.hasNextInt() ? scanner.nextInt() : 0;

        StringBuilder sb = new StringBuilder();
        if (n >= 2) {
            boolean[] composite = new boolean[n + 1];
            for (int i = 2; (long) i * i <= n; i++) {
                if (!composite[i]) {
                    for (int j = i * i; j <= n; j += i) {
                        composite[j] = true;
                    }
                }
            }
            boolean first = true;
            for (int i = 2; i <= n; i++) {
                if (!composite[i]) {
                    if (!first) sb.append(' ');
                    sb.append(i);
                    first = false;
                }
            }
        }
        System.out.println(sb.toString());
    }
}
