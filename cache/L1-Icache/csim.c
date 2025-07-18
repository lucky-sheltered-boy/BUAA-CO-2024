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
int parse_cmd(int args, char **argv, int *s, int *E, int *b, char *filename) {
    int flag[4] = {0};
    int flag_num = 4;
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
void printSummary(long long int hits, long long int misses, long long int evictions) {
    printf("hits:%lld misses:%lld evictions:%lld\n", hits, misses, evictions);
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
    unsigned long long int time;
    char tags[70];
} Cacheline;

typedef struct Group {
    Cacheline *lines;
    int E;
} Group;

long long int hits = 0, misses = 0, evictions = 0;
unsigned long long int time = 0;
Group *data_groups = NULL;
Group *instr_groups = NULL;
unsigned long long int instr[1000000] = {0};
int instr_index = 0;
int s_instr = 3, E_instr = 2, b_instr = 5;

void add_block(Group *groups, int index, char *tags, int flag);

void initialize(int ss, int E) {
	int s = (1 << ss);
    data_groups = (Group*)malloc(sizeof(Group) * s);
    //printf("sizeof groups = %d", sizeof(groups)/sizeof(Group));
    int i = 0, j = 0;
    for (i = 0; i < s; i++) {
        data_groups[i].E = E;
        //printf("E = %d",E);
        data_groups[i].lines = (Cacheline*)malloc(sizeof(Cacheline) * E);
        //printf("sizeof lines = %d",sizeof(groups[i].lines)/sizeof(Cacheline));
        Cacheline *lines = data_groups[i].lines;
        for (j = 0; j < E; j++) {
            lines[j].valid = 0;
            lines[j].time = 0;
            lines[j].tags[0] = '\0';
        }
        //printf("Initialized group %d with %d lines.\n", i, E);
    }
    int s2 = (1 << s_instr);
    instr_groups = (Group*)malloc(sizeof(Group) * s2);
    //printf("sizeof groups = %d", sizeof(groups)/sizeof(Group));
    i = 0;
    j = 0;
    for (i = 0; i < s2; i++) {
        instr_groups[i].E = E_instr;
        //printf("E = %d",E);
        instr_groups[i].lines = (Cacheline*)malloc(sizeof(Cacheline) * E_instr);
        //printf("sizeof lines = %d",sizeof(groups[i].lines)/sizeof(Cacheline));
        Cacheline *lines = instr_groups[i].lines;
        for (j = 0; j < E_instr; j++) {
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

int load(Group *groups, int index, char *tags, int flag) {
	if (probe(groups, index, tags) == -1) {
		add_block(groups, index, tags, flag);
		if (flag == 1) {
            misses++;
		    //printf(" load  miss ");
        }
	} else {
		update(groups, index, tags);
		if (flag == 1) {
            hits++;
		    //printf(" load  hit ");
        }
	}
}

int store(Group *groups, int index, char *tags, int flag) {
	if (probe(groups, index, tags) == -1) {
		add_block(groups, index, tags, flag);
		if (flag) misses++;
		//printf(" miss ");
	} else {
		update(groups, index, tags);
		if (flag) hits++;
		//printf(" hit ");
	}
}

int modify(Group *groups, int index, char *tags, int flag) {
	load(groups, index, tags, flag);
	store(groups, index, tags, flag);
}

void add_block(Group *groups, int index, char *tags, int flag) {
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
	if (flag) evictions++; 
}

void add_instr(unsigned long long address) {
    instr[++instr_index] = address;
}

int is_verge_instr(unsigned long long address) {
    // Check if the instruction is a verge instruction
    // For simplicity, we assume that verge instructions are those that end with 0x00
    return ((address & 0x18) == 0x18);
}

int is_eligible_instr(unsigned long long address) {
    // Check if the instruction is eligible for prefetching
    // For simplicity, we assume that eligible instructions are those that end with 0x00
    if (instr_index < 3) return 0;
    if (instr[instr_index] == instr[instr_index - 1] + 8 && 
    instr[instr_index - 1] == instr[instr_index - 2] + 8) {
        return 1;
    } else {
        return 0;
    }
}

#pragma endregion

int main(int args, char **argv) {

#pragma region Parse
    int s, E, b;
    char filename[1024];
    if (parse_cmd(args, argv, &s, &E, &b, filename) != 0) {
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
        int index;
        char tags[70] = {0};
        if (op == 'L' || op == 'S' || op == 'M') {
            index = get_index(address, s, E, b);
            get_tags(address, s, E, b, tags);
        } else {
            index = get_index(address, s_instr, E_instr, b_instr);
            get_tags(address, s_instr, E_instr, b_instr, tags);
        }
        //printf("op = %c, index = %d, tags = %s ", op, index, tags);
        switch(op) {
            case 'L': {
                load(data_groups, index, tags, 1);
                //printf("\n");
                break;
            }
            case 'S': {
				store(data_groups, index, tags, 1);
				//printf("\n");
                break;
            }          
            case 'M': {
				modify(data_groups, index, tags, 1);
				//printf("\n");
                break;
            }
            case 'P': {
                load(instr_groups, index, tags, 0);
                //puts("\n");
                break;
            }
            case 'I': {
                load(instr_groups, index, tags, 1);
                add_instr(address);
                if (is_verge_instr(address) && is_eligible_instr(address)) {
                    unsigned long long int next_address = address + 8;
                    int next_index = get_index(next_address, s_instr, E_instr, b_instr);
                    char next_tags[70] = {0};
                    get_tags(next_address, s_instr, E_instr, b_instr, next_tags);
                    load(instr_groups, next_index, next_tags, 1);
                    add_instr(next_address);
                }
                //printf("\n");
                break;
            }
        }
    }

#pragma endregion

    // [4/4] Your code to output the hits, misses and evictions
    printSummary(hits, misses, evictions);

    // Maybe you can 'free' your cache here

    return 0;
}
