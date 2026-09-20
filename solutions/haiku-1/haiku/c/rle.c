#include <stdio.h>
#include <string.h>

int main() {
    char line[10001];

    if (fgets(line, sizeof(line), stdin) == NULL) {
        return 0;
    }

    // Remove the newline if present
    int len = strlen(line);
    if (len > 0 && line[len - 1] == '\n') {
        line[len - 1] = '\0';
        len--;
    }

    // Process run-length encoding
    for (int i = 0; i < len; ) {
        char current = line[i];
        int count = 1;

        // Count consecutive occurrences of the current character
        while (i + count < len && line[i + count] == current) {
            count++;
        }

        // Print the character and its count
        printf("%c%d", current, count);

        i += count;
    }

    printf("\n");
    return 0;
}
