#!/bin/bash

uid=`id -u`
cgroupdir=/sys/fs/cgroup/memory
testdir=test

if [ $uid != 0 ]
then
	echo "Need to be root"
	exit
fi

if [ ! -d $cgroupdir ]
then
	echo "Non-standard cgroup configuration"
	exit
fi

if [ ! -d $cgroupdir/$testdir ]
then
	echo "Cgroups not setup"
	exit
fi

for pid in $(cat $cgroupdir/$testdir/tasks)
do
	exec echo $pid > $cgroupdir/tasks
done

rmdir $cgroupdir/$testdir
