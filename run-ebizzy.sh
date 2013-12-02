#!/bin/bash

pids=""
EBIZZY="`pwd`/ebizzy/ebizzy-0.3/ebizzy"
LD_PRELOAD_ARG_VANILLA="`pwd`/jemalloc/jemalloc-3.3.1/lib/libjemalloc.so.vanilla"
LD_PRELOAD_ARG_VRANGE="`pwd`/jemalloc/jemalloc-3.3.1/lib/libjemalloc.so.vrange"

usage() {
cat << EOF
usage: $0 options

OPTIONS:
   -h	Show this message
   -p	the number of process
   -t	the number of thread
   -v   Use jemalloc which support vrange system call
EOF
}

while getopts "hvp:t:" OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		v)
			USE_VRANGE=1
			;;
		p)
			NUM_PROC=$OPTARG
			;;
		t)
			NUM_THREAD=$OPTARG
			;;
		?)
			usage
			exit
			;;
	esac
done

if [ -z $NUM_PROC ]
then
	usage
	exit 1
fi

EBIZZY_ARG="-S 30 -n 512 -v"

# debug() { echo "DEBUG: $*" >&2; }
debug() { echo "DEBUG: $*" >&/dev/null; }

waitall() { # PID...
	## Wait for children to exit and indicate whether all exited with 0 status.
	local errors=0
	while :; do
		debug "Processes remaining: $*"
		for pid in "$@"; do
			shift
			if kill -0 "$pid" 2>/dev/null; then
				debug "$pid is still alive."
				set -- "$@" "$pid"
			elif wait "$pid"; then
				debug "$pid exited with zero exit status."
			else
				debug "$pid exited with non-zero exit status."
				((++errors))
			fi
		done
		(("$#" > 0)) || break
		# TODO: how to interrupt this sleep when a child terminates?
		sleep ${WAITALL_DELAY:-1}
	done
	((errors == 0)) 
}

function clean_up {
	echo "signal"
	kill -9 $pids
	echo "wait"
	waitall $pids
}

echo "Process " $NUM_PROC " Thread " $NUM_THREAD
if [ -z $USE_VRANGE ]
then
	echo "No vrange"
else
	echo "Vrange"
fi

trap clean_up SIGHUP SIGINT SIGTERM
while [ $NUM_PROC -gt 0 ]; do
	if [ ! -z $USE_VRANGE ]
	then
		LD_PRELOAD="$LD_PRELOAD_ARG_VRANGE" $EBIZZY $EBIZZY_ARG -t $NUM_THREAD \
			| tee -a ebizzy.log.$NUM_PROC.$NUM_THREAD.vrange > /dev/null &
	else
		LD_PRELOAD="$LD_PRELOAD_ARG_VANILLA" $EBIZZY $EBIZZY_ARG -t $NUM_THREAD \
			| tee -a ebizzy.log.$NUM_PROC.$NUM_THREAD > /dev/null &
	fi
	pids="$pids $!"
	NUM_PROC=$((NUM_PROC - 1))
done

waitall $pids
echo "Done"
