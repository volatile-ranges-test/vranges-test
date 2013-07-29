CFLAGS += -g -Wall -O3 -Wl,-no-as-needed

bins = volatile-test volatile-test-signal
testfile = test

all: ${bins}

testfile:
	dd if=/dev/zero of=${testfile} bs=1M count=1

clean:
	rm -f ${bins} ${testfile}

