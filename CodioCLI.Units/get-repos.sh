#!/bin/bash
# get cli repos

repos=7

for (( i = 1; i <= $repos; i++ )); do
	git clone git@bitbucket.org:codiocontent/cli$i.git 
done