#include <stdio.h>
#include <stdlib.h>

int main() {
    int R, C;
    scanf("%d %d", &R, &C);

    // Allocate matrix
    int **matrix = (int **)malloc(R * sizeof(int *));
    for (int i = 0; i < R; i++) {
        matrix[i] = (int *)malloc(C * sizeof(int));
    }

    // Read the matrix
    for (int i = 0; i < R; i++) {
        for (int j = 0; j < C; j++) {
            scanf("%d", &matrix[i][j]);
        }
    }

    // Output the transposed matrix
    for (int j = 0; j < C; j++) {
        for (int i = 0; i < R; i++) {
            if (i > 0) printf(" ");
            printf("%d", matrix[i][j]);
        }
        printf("\n");
    }

    // Free memory
    for (int i = 0; i < R; i++) {
        free(matrix[i]);
    }
    free(matrix);

    return 0;
}
