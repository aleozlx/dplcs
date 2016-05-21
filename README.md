# LCS algorithm revisited

KEYWORD: HPC tiny project, OpenMP, DP (Dynamic programming), LCS, Assembly commented

## Build
```
make clean all
```

## Run

```
make run
```

## Tweaking direction

File to look at: `dplcs.c` - less than 30 lines. For anything in that file different from what you would've done,
there's probably a reason. Have fun staring at it!

```C
// LCS algorithm with O(n^2) space - triditional way
int lcs2d(char const*restrict seq1, char const*restrict seq2);

// LCS algorithm with O(n) space - some optimization without time-space trade-off, 
// not a whole lot of improvement tho.
int lcs1d(char const*restrict seq1, char const*restrict seq2);

int main();
// To set number of threads, use the following instead:
#pragma omp parallel num_threads(16)
#pragma omp for schedule(static) // OpenMP for-loop parallelization
```

For some dark magic see `dplcs.h`

For assembly addicts, `dplcs1d.asm` might be what you are looking for.

## Conclusion

OpenMP turned out to be a good application to parallelize tasks running LCS algorithm because this algorithm itself is not parallelizable and non-trivial. Different parallelization levels were experimented with, and the default configuration turned out to be the best option. Two versions of LCS were written, one with 2D array (the textbook way :) ) and the other with 1D array, to see if there’s space-time trade off. The 1D array version was optimal both in space and time, that being said it does take some knowledge of HPC to have that written properly. Objdump of this algorithm is also examined to see how well the compile has optimized the code and whether there’s room for further optimization, particularly with parallelization techniques. However, there does not seem to be any. In conclusion, I found this a positive case that supports OpenMP as both easy and efficient parallelization solution, and studied more closely on LCS algorithm especially in terms of what the algorithm translates into on the lower level.
