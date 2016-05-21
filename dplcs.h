#ifndef DPLCS_H
#define DPLCS_H
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>

#if 1
// max(a,b) as gnu99 anonymous function
#define max(a,b) ({ __typeof__ (a) _a = (a); __typeof__ (b) _b = (b); _a > _b ? _a : _b; })

#else
// max(a,b) as ternary operator
#define max(a,b) ((a>b)?(a):(b))

#endif

// ====================
// It's just a tiny project so don't pretend that we don't know these:
// ====================

// Actual sequence size
#define SEQ_SZ (1000)

// Sequence type (including trailing '\n')
typedef char sequence[SEQ_SZ+1];

// Database file descriptor for memory mapping
//  just for sake of saving lines and open() call bc sh can take care of that
#define FD_DATABASE (4)

// Database file size in lines
#define DB_SIZE (3000)

// ====================
// Boiler plate
// ====================

// Debug logger
#if 1
#define debug(...) fprintf(stderr, __VA_ARGS__)
#else
#define debug(...)
#endif

// Load file by file descriptor via memory mapping
static inline void* load(int fd) {
    struct stat _fstat;
    if (fstat(fd, &_fstat) == -1) { perror("load() fstat()"); return NULL; }
    void* addr = (sequence*)(mmap(NULL, _fstat.st_size, PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0));
    if (addr == MAP_FAILED) { perror("load() mmap()"); return NULL; }
    return addr;
}

#endif
