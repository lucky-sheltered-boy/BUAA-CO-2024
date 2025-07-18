#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
 * @brief Print the usage information
 *
 */
void usage() {
    printf("Usage: ./csim -s <num> -E <num> -b <num> -t <file>\n");
    printf("Options:\n");
    printf("  -s <num>   Number of set index bits.\n");
    printf("  -E <num>   Number of lines per set.\n");
    printf("  -b <num>   Number of block offset bits.\n");
    printf("  -t <file>  Trace file.\n");
    printf("\n");
    printf("Examples:\n");
    printf("  linux>  ./csim -s 4 -E 1 -b 4 -t traces/yi.trace\n");
}

/**
 * @brief Parse the arguments. It will store them into *s, *E, *b, the file.
 *
 * @return int 0 means parsed successfully
 */
int parse_cmd(int args, char **argv, int *s, int *E, int *b, int *w, char *filename) {
    int flag[5] = {0};
    int flag_num = 5;
	int i;
    for (i = 0; i < args; i++) {
        char *str = argv[i];
        if (str[0] == '-') {
            if (str[1] == 's' && i < args) {
                i++;
                sscanf(argv[i], "%d", s);
                flag[0] = 1;
            } else if (str[1] == 'E' && i < args) {
                i++;
                sscanf(argv[i], "%d", E);
                flag[1] = 1;
            } else if (str[1] == 'b' && i < args) {
                i++;
                sscanf(argv[i], "%d", b);
                flag[2] = 1;
            } else if (str[1] == 't' && i < args) {
                i++;
                sscanf(argv[i], "%s", filename);
                flag[3] = 1;
            } else if (str[1] == 'w' && i < args) {
                i++;
                sscanf(argv[i], "%d", w);
                flag[4] = 1;
            }
        }
    }
    for (i = 0; i < flag_num; i++) {
        if (flag[i] == 0) {
            printf("./csim: Missing required command line argument\n");
            usage();
            return 1;
        }
    }
    return 0;
}

/**
 * @brief Print the final string.
 *
 */
void printSummary(int hits, int misses, int evictions, int time) {
    printf("hits:%d misses:%d evictions:%d time:%d\n", hits, misses, evictions, time);
}

/**
 * @brief Read and parse one line from the file-ptr trace.
 *
 * @return int 0 for read and parsed successfully
 */
int readline(FILE *trace, char *op, unsigned long long *address, int *request_length) {
    char str[30];
    if (fgets(str, 30, trace) == NULL) {
        return -1;
    }
    sscanf(str, " %c %llx,%d", op, address, request_length);

    return 0;
}

#pragma region Structures-And-Functions

// [1/4] Your code for definition of structures, global variables or functions

typedef struct Cacheline {
    int valid;
    int dirty;
    unsigned long long int time;
    char tags[70];
} Cacheline;

typedef struct Group {
    Cacheline *lines;
    int E;
} Group;

int hits = 0, misses = 0, evictions = 0;
unsigned long long int time = 0, total_time = 0;
int w = 0;
Group *groups = NULL;
void add_block(int index, char *tags);

void initialize(int ss, int E) {
	int s = (1 << ss);
    groups = (Group*)malloc(sizeof(Group) * s);
    //printf("sizeof groups = %d", sizeof(groups)/sizeof(Group));
    int i = 0, j = 0;
    for (i = 0; i < s; i++) {
        groups[i].E = E;
        //printf("E = %d",E);
        groups[i].lines = (Cacheline*)malloc(sizeof(Cacheline) * E);
        //printf("sizeof lines = %d",sizeof(groups[i].lines)/sizeof(Cacheline));
        Cacheline *lines = groups[i].lines;
        for (j = 0; j < E; j++) {
            lines[j].valid = 0;
            lines[j].dirty = 0;
            lines[j].time = 0;
            lines[j].tags[0] = '\0';
        }
        //printf("Initialized group %d with %d lines.\n", i, E);
    }
}

int get_index(unsigned long long address, int s, int E, int b) {
    int ret = 0;
    int i = 0, j = 0;
    for (i = b; i < b + s; i++) {
        int bit = ((address >> i) & 1);
        j = i - b;
        ret |= (bit << j);
    }
    return ret;
}

void get_tags(unsigned long long address, int s, int E, int b, char *tags) {
    int i = 0, j = 0;
    for (i = 63; i >= b + s; i--) {
        int bit = ((address >> i) & 1);
        tags[j++] = bit + '0';
    }
    tags[j] = '\0';
}

int probe(int index, char *tags) {
    total_time += 5;
	Group group = groups[index];
	int E = group.E;
	Cacheline *lines = group.lines;
	int i;
	for (i = 0; i < E; i++) {
		if (lines[i].valid == 1 && strcmp(lines[i].tags, tags) == 0) {
			return 0;
		} 
	}
	return -1;
}

void update(int index, char *tags) {
	Group group = groups[index];
	int E = group.E;
	Cacheline *lines = group.lines;
	int i;
	for (i = 0; i < E; i++) {
		if (lines[i].valid == 1 && strcmp(lines[i].tags, tags) == 0) {
			lines[i].time = ++time;
		} 
	}
}

void set_dirty(int index, char *tags) {
    Group group = groups[index];
    int E = group.E;
    Cacheline *lines = group.lines;
    int i;
    for (i = 0; i < E; i++) {
        if (lines[i].valid == 1 && strcmp(lines[i].tags, tags) == 0) {
            lines[i].dirty = 1;
            return;
        } 
    }
}

int load(int index, char *tags) {
	if (probe(index, tags) == -1) {
		add_block(index, tags);
		misses++;
		//printf(" miss ");
	} else {
		update(index, tags);
		hits++;
		//printf(" hit ");
	}
}

int store(int index, char *tags) {
	if (probe(index, tags) == -1) {
		add_block(index, tags);
		misses++;
		//printf(" miss ");
	} else {
        set_dirty(index, tags);
        if (w == 1) {
            total_time += 50; // Write time
        }
		update(index, tags);
		hits++;
		//printf(" hit ");
	}
}

int modify(int index, char *tags) {
	load(index, tags);
	store(index, tags);
}

void add_block(int index, char *tags) {
    total_time += 50;
	Group group = groups[index];
	int E = group.E;
	Cacheline *lines = group.lines;
	int i = 0;
	unsigned long long int min = lines[0].time;
	int mark = 0;
	for (i = 0; i < E; i++) {
		if (lines[i].valid == 0) {
			strcpy(lines[i].tags, tags);
			lines[i].valid = 1;
			lines[i].time = ++time;
			return;
		} else {
			if (lines[i].time < min) {
				min = lines[i].time;
				mark = i;
			}
		}
	}
	i = mark;
    if (w == 0 && lines[i].dirty == 1) {
        total_time += 50; // Write back time
    }
	strcpy(lines[i].tags, tags);
	lines[i].valid = 1;
    lines[i].dirty = 0;
	lines[i].time = ++time;
	evictions++; 
}

#pragma endregion

int main(int args, char **argv) {

#pragma region Parse
    int s, E, b;
    char filename[1024];
    if (parse_cmd(args, argv, &s, &E, &b, &w, filename) != 0) {
        return 0;
    }
    //printf("s = %d, E = %d, b = %d", s, E, b);
#pragma endregion

#pragma region Cache-Init

    // [2/4] Your code for initialzing your cache
    // You can use variables s, E and b directly.
    initialize(s, E);
#pragma endregion

#pragma region Handle-Trace
    FILE *trace = fopen(filename, "r");
    char op;
    unsigned long long address;
    int request_length;

    while (readline(trace, &op, &address, &request_length) != -1) {
        // [3/4] Your code for handling the trace line
        int index = get_index(address, s, E, b);
        char tags[70] = {0};
        get_tags(address, s, E, b, tags);
        //printf("op = %c, index = %d, tags = %s ", op, index, tags);
        switch(op) {
            case 'L': {
                load(index, tags);
                //printf("\n");
                break;
            }
            case 'S': {
				store(index, tags);
				//printf("\n");
                break;
            }          
            case 'M': {
				modify(index, tags);
				//printf("\n");
                break;
            }
        }
    }

#pragma endregion

    // [4/4] Your code to output the hits, misses and evictions
    printSummary(hits, misses, evictions, total_time);

    // Maybe you can 'free' your cache here

    return 0;
}
