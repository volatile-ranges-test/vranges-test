#!/bin/bash
#usage $0 <user>

user=$1
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

mkdir $cgroupdir/$testdir
echo 1M > $cgroupdir/$testdir/memory.limit_in_bytes

chown -R $user $cgroupdir/$testdir 
