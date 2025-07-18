/* transpose function of 32 x 32*/
void transpose_32x32(int M, int N, int A[N][M], int B[M][N]) {
    /* Your Code Here [1/3] */
    int t[12] = {0};
    int i, j, ii, jj;
    for (ii = 0; ii < N; ii += 8) {
        for (jj = 0; jj < M; jj += 8) {
            for (i = ii; i < ii + 8 && i < N; i++) {
                for (j = jj; j < jj + 8 && j < M; j++) {
                    int row = i - ii;
                    int col = j - jj;
                    if (row == col) {
                        t[row] = A[i][j]; // Store diagonal element temporarily
                    } else {
                        B[j][i] = A[i][j]; // Transpose non-diagonal elements
                    }
                }
            }
            for (i = 0; i < 8; i++) {
                B[jj + i][ii + i] = t[i]; // Place diagonal elements back
            }
        }
    }
}

/* transpose function of 64 x 64*/
// void transpose_64x64(int M, int N, int A[N][M], int B[M][N]) {
//     /* Your Code Here [2/3] */
//    int t[12] = {0};
//     int i, j, ii, jj;
//     for (ii = 0; ii < N; ii += 8) {
//         for (jj = 0; jj < M; jj += 8) {
//             for (i = ii; i < ii + 8 && i < N; i++) {
//                 for (j = jj; j < jj + 8 && j < M; j++) {
//                     int row = i - ii;
//                     int col = j - jj;
//                     if (row == col) {
//                         t[row] = A[i][j]; // Store diagonal element temporarily
//                     } else {
//                         B[j][i] = A[i][j]; // Transpose non-diagonal elements
//                     }
//                 }
//             }
//             for (i = 0; i < 8; i++) {
//                 B[jj + i][ii + i] = t[i]; // Place diagonal elements back
//             }
//         }
//     }
// }

/*
 * transpose_64x64 - A simple transpose function for a 64x64 matrix,
 * designed to minimize cache misses.
 */
/*
 * transpose_64x64 - A highly optimized transpose function for a 64x64 matrix
 * that minimizes cache misses by using a blocking strategy of 8x8 and
 * carefully choreographing data movement within blocks to avoid cache conflicts.
 */
void transpose_64x64(int M, int N, int A[N][M], int B[M][N]) {
    int i, j, k, l;
    int t0, t1, t2, t3, t4, t5, t6, t7;

    // Iterate over the 64x64 matrix in 8x8 blocks
    for (i = 0; i < N; i += 8) {
        for (j = 0; j < M; j += 8) {
            
            // Step 1: Transpose the top-left 4x4 of the A-block (A_TL) to B's top-left (B_TL)
            // and move A's top-right 4x4 (A_TR) into B's top-right (B_TR) as temporary storage.
            // This loop handles the first 4 rows of the 8x8 A-block.
            for (k = i; k < i + 4; k++) {
                // Read a full row of 8 elements from A to maximize spatial locality.
                t0 = A[k][j + 0]; t1 = A[k][j + 1]; t2 = A[k][j + 2]; t3 = A[k][j + 3];
                t4 = A[k][j + 4]; t5 = A[k][j + 5]; t6 = A[k][j + 6]; t7 = A[k][j + 7];
                
                // Write to B. This places A_TL's data correctly and uses B_TR as temp storage for A_TR's data.
                B[j + 0][k] = t0;
                B[j + 1][k] = t1;
                B[j + 2][k] = t2;
                B[j + 3][k] = t3;
                B[j + 0][k + 4] = t4; // Temporarily stored
                B[j + 1][k + 4] = t5; // Temporarily stored
                B[j + 2][k + 4] = t6; // Temporarily stored
                B[j + 3][k + 4] = t7; // Temporarily stored
            }

            // Step 2: Now handle the bottom half of the A-block and fix the misplaced data in B.
            // We iterate through the columns of the block.
            for (l = 0; l < 4; l++) {
                // 2a: Read a row from A's bottom-left (A_BL).
                t0 = A[i + 4][j + l]; t1 = A[i + 5][j + l]; t2 = A[i + 6][j + l]; t3 = A[i + 7][j + l];
                
                // 2b: Read the temporarily stored row from B's top-right (B_TR).
                t4 = B[j + l][i + 4]; t5 = B[j + l][i + 5]; t6 = B[j + l][i + 6]; t7 = B[j + l][i + 7];
                
                // 2c: Write the data from A_BL to its correct destination (B_TR).
                B[j + l][i + 4] = t0; B[j + l][i + 5] = t1; B[j + l][i + 6] = t2; B[j + l][i + 7] = t3;

                // 2d: Write the temporarily stored data to its final destination (B_BL).
                B[j + l + 4][i + 0] = t4; B[j + l + 4][i + 1] = t5; B[j + l + 4][i + 2] = t6; B[j + l + 4][i + 3] = t7;
            }

            // Step 3: Finally, transpose the bottom-right 4x4 of the A-block (A_BR) to B's bottom-right (B_BR).
            for (k = i + 4; k < i + 8; k++) {
                t0 = A[k][j + 4]; t1 = A[k][j + 5]; t2 = A[k][j + 6]; t3 = A[k][j + 7];
                B[j + 4][k] = t0;
                B[j + 5][k] = t1;
                B[j + 6][k] = t2;
                B[j + 7][k] = t3;
            }
        }
    }
}

/* transpose function of 61 x 67*/
#define BLOCK_SIZE 16
void transpose_61x67(int M, int N, int A[N][M], int B[M][N]) {
    int i, j, k, l;

    // The outer loops (i and j) iterate over the matrix in blocks of BLOCK_SIZE.
    // 'i' iterates over the rows of A (which correspond to columns of B).
    // 'j' iterates over the columns of A (which correspond to rows of B).
    for (i = 0; i < N; i += BLOCK_SIZE) {
        for (j = 0; j < M; j += BLOCK_SIZE) {

            // The inner loops (k and l) perform the transpose within one block.
            // It's crucial to ensure these loops do not go beyond the matrix
            // boundaries (N and M), as the last blocks might be smaller.
            // 'k' iterates through the rows of the current A-block.
            for (k = i; k < i + BLOCK_SIZE && k < N; k++) {

                // 'l' iterates through the columns of the current A-block.
                for (l = j; l < j + BLOCK_SIZE && l < M; l++) {
                    // The core transpose operation: A[k][l] is moved to B[l][k].
                    // Because 'k' and 'l' are constrained to a small block, the memory
                    // locations for both A and B have high spatial and temporal locality,
                    // significantly reducing cache misses compared to a naive transpose.
                    B[l][k] = A[k][l];
                }
            }
        }
    }
}
