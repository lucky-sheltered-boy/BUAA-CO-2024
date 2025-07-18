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
int parse_cmd(int args, char **argv, char *filename) {
    int flag_num = 1;
    int flag[1] = {0};

    for (int i = 0; i < args; i++) {
        char *str = argv[i];
        if (str[0] == '-') {
            if (str[1] == 't' && i < args) {
                i++;
                sscanf(argv[i], "%s", filename);
                flag[0] = 1;
            }
        }
    }
    for (int i = 0; i < flag_num; i++) {
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
void printSummary(int layer, int hits, int misses, int evictions) {
    printf("L%d: hits:%d misses:%d evictions:%d\n", layer, hits, misses, evictions);
}

/**
 * @brief Read and parse one line from the file-ptr trace.
 *
 * @return int 0 for read and parsed successfully
 */
int readline(FILE *trace, int *core, char *op, unsigned long long *address, int *request_length) {
    char str[30];
    if (fgets(str, 30, trace) == NULL) {
        return -1;
    }
    sscanf(str, "%d %c %llx,%d", core, op, address, request_length);

    return 0;
}

#pragma region Structures-And-Functions

// [1/4] Your code for definition of structures, global variables or functions

typedef struct Cacheline {
    int valid;
    unsigned long long int time;
    char tags[70];
} Cacheline;

typedef struct Group {
    Cacheline *lines;
    int E;
} Group;

int hits_L1 = 0, misses_L1 = 0, evictions_L1 = 0;
int hits_L2 = 0, misses_L2 = 0, evictions_L2 = 0;
int s_L1 = 4, E_L1 = 8, b_L1 = 4; // L1 cache parameters
int s_L2 = 6, E_L2 = 8, b_L2 = 6; // L2 cache parameters
unsigned long long int time = 0;
Group **groups_L1 = NULL;
Group *groups_L2 = NULL;

void add_block(Group *groups, int index, char *tags, int layer);

void initialize() {
	int s1 = (1 << s_L1);
    int s2 = (1 << s_L2);
    groups_L1 = (Group**)malloc(sizeof(Group*) * 4);
    //printf("sizeof groups = %d", sizeof(groups)/sizeof(Group));
    int i = 0, j = 0, k = 0;
    for (k = 0; k < 4; k++) {
        groups_L1[k] = (Group*)malloc(sizeof(Group) * s1);
        for (i = 0; i < s1; i++) {
            groups_L1[k][i].E = E_L1;
            //printf("E = %d",E);
            groups_L1[k][i].lines = (Cacheline*)malloc(sizeof(Cacheline) * E_L1);
            //printf("sizeof lines = %d",sizeof(groups[i].lines)/sizeof(Cacheline));
            Cacheline *lines = groups_L1[k][i].lines;
            for (j = 0; j < E_L1; j++) {
                lines[j].valid = 0;
                lines[j].time = 0;
                lines[j].tags[0] = '\0';
            }
            //printf("Initialized group %d with %d lines.\n", i, E);
        }
    }

    groups_L2 = (Group*)malloc(sizeof(Group) * s2);
    //printf("sizeof groups = %d", sizeof(groups)/sizeof(Group));
    for (i = 0; i < s2; i++) {
        groups_L2[i].E = E_L2;
        //printf("E = %d",E);
        groups_L2[i].lines = (Cacheline*)malloc(sizeof(Cacheline) * E_L2);
        //printf("sizeof lines = %d",sizeof(groups[i].lines)/sizeof(Cacheline));
        Cacheline *lines = groups_L2[i].lines;
        for (j = 0; j < E_L2; j++) {
            lines[j].valid = 0;
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

int probe(Group *groups, int index, char *tags) {
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

void update(Group *groups, int index, char *tags) {
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

int load(int core, unsigned long long address) {
    int index1 = get_index(address, s_L1, E_L1, b_L1);
    int index2 = get_index(address, s_L2, E_L2, b_L2);
    char tags1[70] = {0};
    char tags2[70] = {0};
    get_tags(address, s_L1, E_L1, b_L1, tags1);
    get_tags(address, s_L2, E_L2, b_L2, tags2);
	if (probe(groups_L1[core], index1, tags1) == -1) {
        misses_L1++;
        if (probe(groups_L2, index2, tags2) == -1) {
            misses_L2++;
            add_block(groups_L1[core], index1, tags1, 1);
            add_block(groups_L2, index2, tags2, 2);
        } else {
            add_block(groups_L1[core], index1, tags1, 1);
            update(groups_L2, index2, tags2);
            hits_L2++;
        }
	} else {
		update(groups_L1[core], index1, tags1);
		hits_L1++;
		//printf(" hit ");
	}
}

int store(Group *groups, int index, char *tags) {
	
}

int modify(Group *groups, int index, char *tags) {
	
}

void add_block(Group *groups, int index, char *tags, int layer) {
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
	strcpy(lines[i].tags, tags);
	lines[i].valid = 1;
	lines[i].time = ++time;
	if (layer == 1) {
        evictions_L1++;
    } else if (layer == 2) {
        evictions_L2++;
    }
}

#pragma endregion

int main(int args, char **argv) {

#pragma region Parse
    char filename[1024];
    if (parse_cmd(args, argv, filename) != 0) {
        return 0;
    }
    //printf("s = %d, E = %d, b = %d", s, E, b);
#pragma endregion

#pragma region Cache-Init

    // [2/4] Your code for initialzing your cache
    // You can use variables s, E and b directly.
    initialize();
#pragma endregion

#pragma region Handle-Trace
    FILE *trace = fopen(filename, "r");
    char op;
    unsigned long long address;
    int request_length;
    int core;

    while (readline(trace, &core, &op, &address, &request_length) != -1) {
        // [3/4] Your code for handling the trace line
        //printf("op = %c, index = %d, tags = %s ", op, index, tags);
        switch(op) {
            case 'L': {
                load(core, address);
                //printf("\n");
                break;
            }
            case 'S': {
				load(core, address);
				//printf("\n");
                break;
            }          
            case 'M': {
				load(core, address);
                load(core, address);
				//printf("\n");
                break;
            }
        }
    }

#pragma endregion

    // [4/4] Your code to output the hits, misses and evictions
    printSummary(1, hits_L1, misses_L1, evictions_L1);
    printSummary(2, hits_L2, misses_L2, evictions_L2);
    // Maybe you can 'free' your cache here

    return 0;
}
