#!/bin/bash
# workspace-reset file hierarchy

WORKSPACE=/home/codio/workspace/
arg=$1

function init_workspace {
	mkdir "${WORKSPACE}dir1"
	touch "${WORKSPACE}dir1/file1.txt" "${WORKSPACE}empty-file.txt"
	echo "Project files have been reseted"
	sleep 2
	clear
}

function reset_workspace {
	rm -r "${WORKSPACE}dir1"
	rm -r "${WORKSPACE}empty-file.txt"
	echo "Reseting project files and directories"
	sleep 2
	init_workspace
}

function reset_challenges {
	find "${WORKSPACE}.guides/bashtests/" -path "*.txt" -delete
	# find "${WORKSPACE}/bashtests/" -path "*.txt" -delete
	echo "Project challenges files have been reseted."
	sleep 2
	clear
}

case $arg in
	challenges ) reset_challenges
		;;
	workspace ) reset_workspace
		;;
	* ) echo "'$arg' doesn't match any available arguments" 
		;;
esac