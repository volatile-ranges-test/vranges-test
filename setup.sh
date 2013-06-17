#!/bin/bash

curr_user=`id | cut -d "(" -f 2 | cut -d ")" -f 1`

echo $curr_user

echo "Now we need root"
sudo ./setup-cgroups.sh $curr_user
