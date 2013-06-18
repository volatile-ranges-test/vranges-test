#!/bin/bash

cgroupdir=/sys/fs/cgroup/memory
testdir=test
curr_user=`id | cut -d "(" -f 2 | cut -d ")" -f 1`

echo $curr_user

echo "Now we need root"
sudo ./setup-cgroups.sh $curr_user

echo $$ > $cgroupdir/$testdir/tasks

echo "Now we are trapped in the correct cgroup"
cat /proc/self/cgroup | grep memory

echo "Running Tests"
./run-tests.sh

echo "Tearing down cgroups"
sudo ./teardown-cgroup.sh
