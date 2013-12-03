#!/bin/bash

if [ ! -d ebizzy ]
then
	mkdir ebizzy;
	pushd ebizzy;
	wget http://heanet.dl.sourceforge.net/sourceforge/ebizzy/ebizzy-0.3.tar.gz
	tar -xzf ebizzy-0.3.tar.gz
	pushd ebizzy-0.3
	gcc -o ebizzy ebizzy.c -lpthread
	popd
	popd
fi

if [ ! -d jemalloc ]
then
	mkdir jemalloc
	pushd jemalloc
	wget http://www.canonware.com/download/jemalloc/jemalloc-3.3.1.tar.bz2
	tar -xjf jemalloc-3.3.1.tar.bz2
	pushd jemalloc-3.3.1
	./configure
	make all -j 4
	mv lib/libjemalloc.so.1 lib/libjemalloc.so.vanilla
	patch -p1 < ../../0001-*.patch
	patch -p1 < ../../0002-*.patch
	./configure
	make all -j 4
	mv lib/libjemalloc.so.1 lib/libjemalloc.so.vrange
	popd
	popd
fi
