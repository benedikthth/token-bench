#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

typedef struct {
    const char *input;
    int pos;
} Parser;

Parser* parser_create(const char *input) {
    Parser *p = malloc(sizeof(Parser));
    p->input = input;
    p->pos = 0;
    return p;
}

void parser_free(Parser *p) {
    free(p);
}

void skip_whitespace(Parser *p) {
    while (isspace((unsigned char)p->input[p->pos])) {
        p->pos++;
    }
}

int parse_number(Parser *p) {
    skip_whitespace(p);
    int num = 0;
    while (isdigit((unsigned char)p->input[p->pos])) {
        num = num * 10 + (p->input[p->pos] - '0');
        p->pos++;
    }
    return num;
}

int parse_expression(Parser *p);

int parse_primary(Parser *p) {
    skip_whitespace(p);
    if (p->input[p->pos] == '(') {
        p->pos++; // consume '('
        int result = parse_expression(p);
        skip_whitespace(p);
        p->pos++; // consume ')'
        return result;
    }
    return parse_number(p);
}

int parse_factor(Parser *p) {
    int left = parse_primary(p);
    while (1) {
        skip_whitespace(p);
        char op = p->input[p->pos];
        if (op == '*' || op == '/') {
            p->pos++;
            int right = parse_primary(p);
            if (op == '*') {
                left = left * right;
            } else {
                left = left / right;
            }
        } else {
            break;
        }
    }
    return left;
}

int parse_expression(Parser *p) {
    int left = parse_factor(p);
    while (1) {
        skip_whitespace(p);
        char op = p->input[p->pos];
        if (op == '+' || op == '-') {
            p->pos++;
            int right = parse_factor(p);
            if (op == '+') {
                left = left + right;
            } else {
                left = left - right;
            }
        } else {
            break;
        }
    }
    return left;
}

int main() {
    char line[1024];
    while (fgets(line, sizeof(line), stdin)) {
        // Remove newline
        line[strcspn(line, "\n")] = 0;

        Parser *p = parser_create(line);
        int result = parse_expression(p);
        printf("%d\n", result);
        parser_free(p);
    }
    return 0;
}
