#!/bin/bash
# bash_history edit

bash_history=~/.bash_history
BASHDIR=/home/codio/workspace/.guides
check_file=cli-1-4
hist_file="$BASHDIR/bashtests/CLI1/$check_file.txt"

echo "$check_file" >> $bash_history
grep -A2000 -e "^$check_file" $bash_history > "$BASHDIR/bashtests/CLI1/${check_file}.txt"

# Must match for erasing history
RES_HIST=0
COUNT=0
QCOUNT=8

# Reset history
function reset_history {
	if [[ $RES_HIST -eq $QCOUNT ]]; then
		echo "$arg" > ~/.bash_history
	fi
}

function expect_command 
{
	if grep -Fxq "$1" "$hist_file"
	then
		response "$2" $COUNT
	else 
		tell_error "$2" $COUNT
	fi
}

function expect_commands 
{
	args_array=()
	for (( i = 2; i <= $#; i++ )); do
		args_array[i]=${!i}
	done
	for (( i = 2; i <= $#; i++ )); do		
		if grep -Fxq "${args_array[$i]}" "$hist_file" || grep -Fxq "${args_array[$i]}/" "$hist_file" || grep -Fxq "${args_array[$i]} " "$hist_file"
		then
			found_arg="${args_array[$i]}"
			response "$1" $COUNT
			return
		else
			tell_error "$1" $COUNT
			return
		fi
	done
}

function expect_file 
{
	if [[ -f "$1" ]]; then
		response "$2" $COUNT
	else 
		tell_error "$2" $COUNT
	fi
}

function expect_directory
{
	if [[ -d "$1" ]]; then
		response "$2" $COUNT
	else 
		tell_error "$2" $COUNT
	fi
}

function tell_error 
{
	echo -e "[Error  ] Task $2. Expected: $1. Try again."
	test_command
	# return 1
}

function response 
{
	echo -e "[Correct] Task $2. ${1}"
	(( RES_HIST ++ ))
	test_command
}

function test_command {
	(( COUNT ++ ))
	if [[ $COUNT -le $QCOUNT ]]; then
		case $COUNT in
			1 )
				expect_directory "/home/codio/workspace/test-dir1" "create test-dir1 directory on ~/workspace folder"
				# expect_directory "$BASHDIR/workspace-cli1/test-dir1" "create test-dir1 directory on ~/workspace folder"
				;;
			2 )
				expect_commands "list ~/workspace directory content" "ls" "ls ."
				;;
			3 )
				expect_commands "enter test-dir1 directory" "cd test-dir1" "cd test-dir1/" "cd test-dir1 " "cd test-dir1/ "
				;;
			4 )
				expect_command "pwd" "print the path to working directory"
				;;
			5 )
				expect_file "/home/codio/workspace/test-dir1/test-file1.txt" "create '~/workspace/test-dir1/test-file1.txt file'"
				# expect_file "$BASHDIR/workspace-cli1/test-dir1/test-file1.txt" "create '~/workspace/test-dir1/test-file1.txt file'"
				;;
			6 )
				expect_command "ls -a" "list hidden files"
				;;
			7 )
				expect_command "cd .." "get back one directory level"
				;;
			8 )
				expect_command "ls -l" "list files in vertical column layout"
				;;
		esac
	else 
		reset_history
	fi
}


test_command