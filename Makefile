SHELL=/bin/bash
PYTHON=python2
TIME=./time.x64
SSH=ssh
RSYNC=rsync -v
RM=rm -rvf
CC=gcc
OBJDUMP=objdump -d -M intel -S -l

# CFLAGS=-std=gnu99 -g -pg -O2 -Wall -Wno-unused-result -fopenmp
CFLAGS=-std=gnu99 -O2 -Wall -Wno-unused-result -fopenmp -march=native

.PHONY: all clean run clean_remote run_remote

all: dplcs

run: all sample_input
	$(PYTHON) gen_data.py 1 | $(TIME) ./dplcs 4<sample_input > output
ifneq "$(wildcard gmon.out)" ""
	@gprof -a -b ./dplcs > dplcs.profile
endif

run_remote: dplcs.c dplcs.h gen_data.py Makefile time.x64
	$(RSYNC) $^ threads:project/
	$(SSH) threads 'cd project && make run'

clean_remote: Makefile
	$(RSYNC) $^ threads:project/
	$(SSH) threads 'cd project && make clean'

clean:
	$(RM) dplcs dplcs.dump dplcs.profile sample_input output gmon.out

dplcs: dplcs.c
	$(CC) $(CFLAGS) -o $@ $^
	$(OBJDUMP) $@ > $@.dump
	
sample_input:
	$(PYTHON) gen_data.py > $@
