#!/bin/bash
# makedir

bash_history=~/.bash_history
BASHDIR=/home/codio/workspace/.guides
check_file=cli-2-1
hist_file="$BASHDIR/bashtests/CLI2/$check_file.txt"

echo "$check_file" >> $bash_history
grep -A2000 -e "^$check_file" $bash_history > "$BASHDIR/bashtests/CLI2/${check_file}.txt"

# Must match for erasing history
RES_HIST=0
COUNT=0
QCOUNT=1

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

function expect_directories
{
	args_array=()
	for (( i = 1; i <= $#; i++ )); do
		args_array[i]=${!i}
		found_arg="${args_array[$i]}"
		if [[ $i -le $# && -d "${args_array[$i]}" ]]; then
			echo -e "[Correct] Task $COUNT. ${found_arg}"
		else
			echo -e "[Missing] Task $COUNT. Expected: ${found_arg}"
		fi
	done
	test_command
}

function tell_error 
{
	echo -e "[Error  ] Task 1. Expected: $1. Try again."
	test_command
	# return 1
}

function response 
{
	echo -e "[Correct] Task 1. ${1}"
	(( RES_HIST ++ ))
	test_command
}

function test_command {
	(( COUNT ++ ))
	if [[ $COUNT -le $QCOUNT ]]; then
		case $COUNT in
			1 )
				expect_directories "/home/codio/workspace/test-website/css" "/home/codio/workspace/test-website/js" "/home/codio/workspace/test-website/img"
				# expect_directory "$BASHDIR/workspace-cli2/test-website/css" "create test-website/css directory on ~/workspace folder"
				;;
		esac
	else 
		reset_history
	fi
}


test_command