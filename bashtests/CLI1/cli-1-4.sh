#!/bin/bash
# bash_history edit

bash_history=~/.bash_history
check_file=cli-1-4
hist_file="$BASHDIR/bashtests/CLI1/$check_file.txt"

echo "$check_file" >> $bash_history
grep -A2000 -e "^cli-1-4" $bash_history > "$BASHDIR/bashtests/CLI1/${check_file}.txt"

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
		response "$1" "$3" $COUNT
	else 
		tell_error "$2" $COUNT
	fi
}

function expect_commands 
{
	args_array=()
	for (( i = 3; i <= $#; i++ )); do
		args_array[i]=${!i}
	done
	for (( i = 3; i <= $#; i++ )); do		
		if grep -FExq "${args_array[$i]}\/? ?" "$hist_file"
		then
			found_arg="${args_array[$i]}"
			response "$found_arg" "$2" $COUNT
			return
		else
			tell_error "$1" $COUNT
			return
		fi
	done
}

function tell_error 
{
	echo -e "ERROR: Task $2. Expected: $1. Try again."
	test_command
	# return 1
}

function response 
{
	echo -e "right: Task $3. The '${1}' command ${2}"
	(( RES_HIST ++ ))
	test_command
}

function test_command {
	(( COUNT ++ ))
	if [[ $COUNT -le $QCOUNT ]]; then
		case $COUNT in
			1 )
				expect_commands "create test-dir1 directory on ~/workspace folder" "created the test-dir1 directory" "mkdir test-dir1" "mkdir test-dir1"
				;;
			2 )
				expect_commands "list ~/workspace directory content" "lists directories" "ls" "ls ."
				;;
			3 )
				expect_commands "enter test-dir1 directory" "entered the test-dir1 directory" "cd test-dir1" "cd test-dir1/"
				;;
			4 )
				expect_command "pwd" "print the path to working directory" "prints the path to the working directory"
				;;
			5 )
				expect_commands "create '~/workspace/test-dir1/test-file1.txt file'" "created the test-file1.txt file" "touch test-file1.txt" "touch test-file1.txt "
				;;
			6 )
				expect_command "ls -a" "list hidden files" "lists hidden files"
				;;
			7 )
				expect_command "cd .." "get back one directory level" "gets back one directory level"
				;;
			8 )
				expect_commands "list hidden files in vertical column layout" "lists dotfiles in a vertical column layout" "ls -al" "ls -la" "ls -l -a" "ls -a -l"
				;;
		esac
	else 
		reset_history
	fi
}


test_command