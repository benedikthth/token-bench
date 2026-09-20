#include <stdio.h>
#include <string.h>

int is_balanced(char *line) {
    int stack[1000];
    int top = -1;

    for (int i = 0; line[i] != '\0'; i++) {
        char c = line[i];

        if (c == '(' || c == '[' || c == '{') {
            // Push opening bracket
            stack[++top] = c;
        } else if (c == ')' || c == ']' || c == '}') {
            // Check if we have a matching opening bracket
            if (top < 0) {
                return 0;  // No opening bracket for this closing bracket
            }

            char open = stack[top--];

            // Check if the brackets match
            if ((c == ')' && open != '(') ||
                (c == ']' && open != '[') ||
                (c == '}' && open != '{')) {
                return 0;  // Mismatched brackets
            }
        }
    }

    // Stack should be empty for balanced brackets
    return top == -1;
}

int main() {
    char line[1000];

    while (fgets(line, sizeof(line), stdin) != NULL) {
        // Remove trailing newline
        int len = strlen(line);
        if (len > 0 && line[len - 1] == '\n') {
            line[len - 1] = '\0';
        }

        if (is_balanced(line)) {
            printf("yes\n");
        } else {
            printf("no\n");
        }
    }

    return 0;
}
