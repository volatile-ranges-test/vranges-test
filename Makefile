CFLAGS=-g -Wall

all:	volatile-test volatile-test-signal

volatile-test:	volatile-test.c
	${CC} ${CFLAGS} -o $@ $@.c

volatile-test-signal:	volatile-test-signal.c
	${CC} ${CFLAGS} -o $@ $@.c
