#include <stdio.h>

int main() {
    int num;

    // Values in descending order with their Roman numeral representations
    int values[] = {1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1};
    const char* numerals[] = {"M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"};

    while (scanf("%d", &num) == 1) {
        // Process each value from largest to smallest
        for (int i = 0; i < 13; i++) {
            // For each value, output its symbol as many times as it fits
            while (num >= values[i]) {
                printf("%s", numerals[i]);
                num -= values[i];
            }
        }
        printf("\n");
    }

    return 0;
}
