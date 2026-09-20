import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        int n = sc.nextInt();

        if (n < 2) {
            System.out.println();
            return;
        }

        // Sieve of Eratosthenes
        boolean[] isPrime = new boolean[n + 1];
        for (int i = 2; i <= n; i++) {
            isPrime[i] = true;
        }

        for (int i = 2; i * i <= n; i++) {
            if (isPrime[i]) {
                for (int j = i * i; j <= n; j += i) {
                    isPrime[j] = false;
                }
            }
        }

        // Collect and output primes
        StringBuilder result = new StringBuilder();
        for (int i = 2; i <= n; i++) {
            if (isPrime[i]) {
                if (result.length() > 0) {
                    result.append(" ");
                }
                result.append(i);
            }
        }

        System.out.println(result.toString());
    }
}
