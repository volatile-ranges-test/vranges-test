CFLAGS += -g -Wall -O3 -Wl,-no-as-needed

bins = volatile-test volatile-test-signal
testfile = test

all: ${bins}

testfile:
	dd if=/dev/zero of=${testfile} bs=1M count=26

clean:
	rm -f ${bins} ${testfile}

