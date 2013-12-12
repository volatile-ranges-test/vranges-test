CFLAGS += -g -Wall -O3 -Wl,-no-as-needed

bins = volatile-test volatile-test-signal
1M-testfile = 1M-testfile

all: ${bins} 1M-testfile external

external:
	./fetch-external-tests.sh

1M-testfile:
	dd if=/dev/zero of=${1M-testfile} bs=1M count=1


clean:
	rm -f ${bins} ${1M-testfile}
	rm -rf ebizzy
	rm -rf jemalloc

