#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *word;
    char *signature;
} WordInfo;

typedef struct {
    char **words;
    int count;
} Group;

int compare_chars(const void *a, const void *b) {
    return *(char *)a - *(char *)b;
}

char *get_signature(const char *word) {
    char *sig = malloc(strlen(word) + 1);
    strcpy(sig, word);
    int len = strlen(sig);
    qsort(sig, len, sizeof(char), compare_chars);
    return sig;
}

int compare_strings(const void *a, const void *b) {
    return strcmp(*(const char **)a, *(const char **)b);
}

int compare_word_infos(const void *a, const void *b) {
    const WordInfo *w1 = (const WordInfo *)a;
    const WordInfo *w2 = (const WordInfo *)b;
    return strcmp(w1->signature, w2->signature);
}

int compare_groups(const void *a, const void *b) {
    const Group *g1 = (const Group *)a;
    const Group *g2 = (const Group *)b;
    return strcmp(g1->words[0], g2->words[0]);
}

int main() {
    WordInfo *words = malloc(10000 * sizeof(WordInfo));
    int word_count = 0;

    char buffer[1000];
    while (fgets(buffer, sizeof(buffer), stdin) != NULL) {
        size_t len = strlen(buffer);
        if (len > 0 && buffer[len-1] == '\n') {
            buffer[len-1] = '\0';
        }

        words[word_count].word = malloc(strlen(buffer) + 1);
        strcpy(words[word_count].word, buffer);
        words[word_count].signature = get_signature(buffer);
        word_count++;
    }

    // Sort by signature to group anagrams together
    qsort(words, word_count, sizeof(WordInfo), compare_word_infos);

    // Create groups
    Group *groups = malloc(word_count * sizeof(Group));
    int group_count = 0;

    int i = 0;
    while (i < word_count) {
        char *current_sig = words[i].signature;
        int group_start = i;

        // Find all words with the same signature
        while (i < word_count && strcmp(words[i].signature, current_sig) == 0) {
            i++;
        }

        int group_size = i - group_start;
        groups[group_count].words = malloc(group_size * sizeof(char *));
        groups[group_count].count = group_size;

        for (int j = 0; j < group_size; j++) {
            groups[group_count].words[j] = words[group_start + j].word;
        }

        // Sort words within the group alphabetically
        qsort(groups[group_count].words, group_size, sizeof(char *), compare_strings);
        group_count++;
    }

    // Sort groups by their first word
    qsort(groups, group_count, sizeof(Group), compare_groups);

    // Output
    for (int i = 0; i < group_count; i++) {
        for (int j = 0; j < groups[i].count; j++) {
            if (j > 0) printf(" ");
            printf("%s", groups[i].words[j]);
        }
        printf("\n");
    }

    return 0;
}
