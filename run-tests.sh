#!/bin/bash

#We should be in the test directory at this point in time.

echo "Current cgroup"
cat /proc/self/cgroup | grep memory

#Just add your test here, we will figure out how to check the
#results later on.
./volatile-test
./volatile-test
./volatile-test
./volatile-test
./volatile-test
./volatile-test

./volatile-test-signal
./volatile-test-signal
./volatile-test-signal
./volatile-test-signal
./volatile-test-signal
