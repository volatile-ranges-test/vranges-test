#!/bin/bash

uid=`id -u`

if [ $uid != 0 ]
then
	echo "Need to be root"
	exit
fi

if [ ! -d /sys/fs/cgroup/memory ]
then
	echo "Non-standard cgroup configuration"
	exit
fi

if [ ! -d /sys/fs/cgroup/memory/test ]
then
	echo "Cgroups not setup"
	exit
fi

for pid in `cat /sys/fs/cgroup/memory/test/tasks`
do
	echo $pid > /sys/fs/cgroup/memory/tasks
done

rmdir /sys/fs/cgroup/memory/test/
