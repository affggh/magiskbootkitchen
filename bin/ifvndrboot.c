#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	if(argc<2) {
		fprintf(stderr, "%s [FILE]\n", argv[0]);
		return 1;
	} else if(access(argv[1], F_OK)!=0) {
		fprintf(stderr, "File does not exist.\n");
		return 1;
	}
	char buf[8];
	FILE *fp = fopen(argv[1], "rb");
	fread(buf, 1, sizeof(buf), fp);
	if(memcmp(buf, "VNDRBOOT", 8)==0) {
		return 0;
	} else {
		return 1;
	}
}