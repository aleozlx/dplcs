#include "dplcs.h"
sequence query, *db; int output[DB_SIZE];

int lcs2d(char const*restrict seq1, char const*restrict seq2){
    short dp[SEQ_SZ+1][SEQ_SZ+1]; memset(dp, 0, sizeof(dp)); // Memory space for dynamic programming
    for(int i=1;i<=SEQ_SZ;++i) for(int j=1;j<=SEQ_SZ;++j) // LCS algorithm
        dp[i][j]=seq1[i-1]==seq2[j-1]?dp[i-1][j-1]+1:max(dp[i-1][j],dp[i][j-1]);
    return dp[SEQ_SZ][SEQ_SZ]; // Return length of LCS
}

int lcs1d(char const*restrict seq1, char const*restrict seq2){
    int current, dp[SEQ_SZ+1]; memset(dp, 0, sizeof(dp)); // Memory space for dynamic programming
    for(int i=0;i<SEQ_SZ;++i) for(int j=0,left=0;j<SEQ_SZ;dp[j]=left,left=current,++j)
        current = seq1[i]==seq2[j]?dp[j]+1:max(dp[j+1],left); // LCS algorithm with 1D array
        //        ^~~~~~~~~~~~~~~~ high branch penalty: 3x speedup if replaced with 1
    return current; // Return length of LCS
}

int main(){
    db = (sequence*)load(FD_DATABASE); // Load sequence database file
    scanf("%s", query); debug("Query: %s\n", query); // Load query sequence
    #pragma omp parallel for schedule(static) // OpenMP for-loop parallelization
    for(int ll=0;ll<DB_SIZE;++ll) output[ll] = lcs1d(db[ll], query); // Full scan
    for(int ll=0;ll<DB_SIZE;++ll) printf("%d\n", output[ll]); // Output
    return 0; // All resources released by OS
}
