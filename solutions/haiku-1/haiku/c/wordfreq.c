#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_WORD_LEN 256
#define INITIAL_CAPACITY 100

typedef struct {
    char *word;
    int count;
} WordCount;

int compare(const void *a, const void *b) {
    const WordCount *wa = (const WordCount *)a;
    const WordCount *wb = (const WordCount *)b;

    // Sort by count descending
    if (wa->count != wb->count) {
        return wb->count - wa->count;
    }
    // Then by word ascending
    return strcmp(wa->word, wb->word);
}

int main() {
    WordCount *words = malloc(INITIAL_CAPACITY * sizeof(WordCount));
    int capacity = INITIAL_CAPACITY;
    int count = 0;

    char buffer[MAX_WORD_LEN];
    int c;
    int word_idx = 0;

    // Read input and extract words
    while ((c = getchar()) != EOF) {
        if (isalpha(c)) {
            // Add lowercase letter to current word
            if (word_idx < MAX_WORD_LEN - 1) {
                buffer[word_idx++] = tolower(c);
            }
        } else {
            // End of word
            if (word_idx > 0) {
                buffer[word_idx] = '\0';

                // Find or add word
                int found = 0;
                for (int i = 0; i < count; i++) {
                    if (strcmp(words[i].word, buffer) == 0) {
                        words[i].count++;
                        found = 1;
                        break;
                    }
                }

                if (!found) {
                    if (count >= capacity) {
                        capacity *= 2;
                        words = realloc(words, capacity * sizeof(WordCount));
                    }
                    words[count].word = malloc(strlen(buffer) + 1);
                    strcpy(words[count].word, buffer);
                    words[count].count = 1;
                    count++;
                }

                word_idx = 0;
            }
        }
    }

    // Handle last word if input doesn't end with non-letter
    if (word_idx > 0) {
        buffer[word_idx] = '\0';

        int found = 0;
        for (int i = 0; i < count; i++) {
            if (strcmp(words[i].word, buffer) == 0) {
                words[i].count++;
                found = 1;
                break;
            }
        }

        if (!found) {
            if (count >= capacity) {
                capacity *= 2;
                words = realloc(words, capacity * sizeof(WordCount));
            }
            words[count].word = malloc(strlen(buffer) + 1);
            strcpy(words[count].word, buffer);
            words[count].count = 1;
            count++;
        }
    }

    // Sort
    qsort(words, count, sizeof(WordCount), compare);

    // Output
    for (int i = 0; i < count; i++) {
        printf("%s %d\n", words[i].word, words[i].count);
    }

    // Free memory
    for (int i = 0; i < count; i++) {
        free(words[i].word);
    }
    free(words);

    return 0;
}
