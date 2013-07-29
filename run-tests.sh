#!/bin/bash

#We should be in the test directory at this point in time.

echo "Current cgroup"
cat /proc/self/cgroup | grep memory

PRESSURE=3

#Just add your test here, we will figure out how to check the
#results later on.
./volatile-test -p $PRESSURE
./volatile-test -p $PRESSURE
./volatile-test -p $PRESSURE
./volatile-test -p $PRESSURE
./volatile-test -p $PRESSURE

./volatile-test-signal -p $PRESSURE
./volatile-test-signal -p $PRESSURE
./volatile-test-signal -p $PRESSURE
./volatile-test-signal -p $PRESSURE
./volatile-test-signal -p $PRESSURE
