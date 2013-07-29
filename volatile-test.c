
#define _GNU_SOURCE
#include <stdio.h>
#include <pthread.h>
#include <sched.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/syscall.h>

#define SYS_vrange 314

#define VRANGE_VOLATILE	0	/* unpin all pages so VM can discard them */
#define VRANGE_NOVOLATILE	1	/* pin all pages so VM can't discard them */

#define VRANGE_MODE_SHARED 0x1	/* discard all pages of the range */



#define VRANGE_MODE 0x1

static int vrange(unsigned long start, size_t length, int mode, int *purged)
{
	return syscall(SYS_vrange, start, length, mode, purged);
}


static int mvolatile(void *addr, size_t length)
{
	return vrange((long)addr, length, VRANGE_VOLATILE, 0);
}


static int mnovolatile(void *addr, size_t length, int* purged)
{
	return vrange((long)addr, length, VRANGE_NOVOLATILE, purged);
}


char* vaddr;
int is_anon = 0;
#define PAGE_SIZE (4*1024)
#define CHUNK (4*1024*4)
#define CHUNKNUM 26
#define FULLSIZE (CHUNK*CHUNKNUM + 2*PAGE_SIZE)

void generate_pressure(megs)
{
	pid_t child;
	int one_meg = 1024*1024;
	char *addr;
	int i, status;

	child = fork();


	if (!child) {
		if (is_anon) {
			/* make sure we write to all the vrange pages
			 *  in order to break the copy-on-write
	 		 */
			for(i=0; i < CHUNKNUM; i++)
				memset(vaddr + (i*CHUNK), '0', CHUNK);
		}

		for (i=0; i < megs; i++) {
			addr = malloc(one_meg);
			bzero(addr, one_meg);		
		}
		exit(0);
	}

	waitpid(child, &status, 0);
	return;
}

int main(int argc, char *argv[])
{
	int i, purged;
	char* file;
	int fd;
	if (argc > 1) {
		file = argv[1];
		fd = open(file, O_RDWR);
		vaddr = mmap(0, FULLSIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	} else {
		is_anon = 1;
		vaddr = malloc(FULLSIZE);
	}

	purged = 0;
	vaddr += PAGE_SIZE-1;
	vaddr -= (long)vaddr % PAGE_SIZE;

	for(i=0; i < CHUNKNUM; i++)
		memset(vaddr + (i*CHUNK), 'A'+i, CHUNK);


	for(i=0; i < CHUNKNUM; ) {
		mvolatile(vaddr + (i*CHUNK), CHUNK);
		i+=2;
	}

//	for(i=0; i < CHUNKNUM; i++)
//		printf("%c\n", vaddr[i*CHUNK]);

	generate_pressure(3);

//	for(i=0; i < CHUNKNUM; i++)
//		printf("%c\n", vaddr[i*CHUNK]);

	for(i=0; i < CHUNKNUM; ) {
		mnovolatile(vaddr + (i*CHUNK), CHUNK, &purged);
		i+=2;
	}

	if (purged)
		printf("Data purged!\n");
	for(i=0; i < CHUNKNUM; i++)
		printf("%c\n", vaddr[i*CHUNK]);
	


	return 0;
}

