#!/bin/bash

curr_user=`id | cut -d "(" -f 2 | cut -d ")" -f 1`

echo $curr_user

echo "Now we need root"
sudo ./setup-cgroups.sh $curr_user

echo $$ > /sys/fs/cgroup/memory/test/tasks

echo "Now we are trapped in the correct cgroup"
cat /proc/self/cgroup | grep memory

echo "Running Tests"
./run-tests.sh

echo "Tearing down cgroups"
sudo ./teardown-cgroup.sh
