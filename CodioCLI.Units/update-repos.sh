#!/bin/bash
# get cli repos

repos=7

function change_dir
{
	cd $1
}

function update_local_repo
{
	git pull origin master
	change_dir ..
}

for (( i = 1; i <= $repos; i++ )); do
	change_dir cli$i
	update_local_repo
done