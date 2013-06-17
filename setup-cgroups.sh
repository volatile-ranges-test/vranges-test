#!/bin/bash
#usage $0 <user>

user=$1
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

mkdir /sys/fs/cgroup/memory/test
echo 1M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes

chown -R $user /sys/fs/cgroup/memory/test 
