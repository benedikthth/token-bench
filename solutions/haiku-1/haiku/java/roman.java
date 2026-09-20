import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Define the mapping of values to roman numerals in descending order
        // Includes subtractive forms: IV, IX, XL, XC, CD, CM
        int[] values = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
        String[] numerals = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};

        while (scanner.hasNextLine()) {
            int n = Integer.parseInt(scanner.nextLine());
            StringBuilder roman = new StringBuilder();

            // Greedily subtract the largest possible value and append the symbol
            for (int i = 0; i < values.length; i++) {
                while (n >= values[i]) {
                    roman.append(numerals[i]);
                    n -= values[i];
                }
            }

            System.out.println(roman.toString());
        }
    }
}
