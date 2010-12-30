/*
 * unmaintainable.c
 * 
 * A deceptively simple/simply deceptive technique for writing
 * unmaintainable code. The following code DOES compile and DOES work.
 * Tested 2010-12-30 using GCC 4.2.1.
 * 
 * Compile it with:
 * 
 * cc unmaintainable.c -o unmaintainable
 * 
 * Run it with:
 * 
 * $ ./unmaintainable apple pear banana
 * The arguments to this program are:
 *   0: ./unmaintainable
 *   1: apple
 *   2: pear
 *   3: banana
 */
#include <stdio.h>

int main(int argc, char *argv[], char**env) {
	int i;

	printf("The arguments to this program are:\n");

	/*
	 * In C, argv[i] compiles to (char*)(argv+i), which is just a pointer to
	 * an address in memory. argv+i is equivalent to i+argv, and
	 * interestingly, the C compiler does not care if you swap the index
	 * and the offset in the array notation. Thus i[argv] is a valid
	 * pointer to the same string as argv[i].
	 */

	for (i=0; i<argc; ++i) {
		printf("  %d: %s\n", i, i[argv]);
	}

	return 0;
}


