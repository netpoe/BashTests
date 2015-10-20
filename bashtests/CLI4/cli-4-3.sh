#!/bin/bash
# echo test

bash_history=~/.bash_history
# BASHDIR=/home/codio/workspace/.guides
check_file=cli-4-3
hist_file="$BASHDIR/bashtests/CLI4/$check_file.txt"

echo "$check_file" >> $bash_history
grep -A2000 -e "^$check_file" $bash_history > "$BASHDIR/bashtests/CLI4/${check_file}.txt"

# Must match for erasing history
RES_HIST=0
COUNT=0
QCOUNT=2

# Reset history
function reset_history {
	if [[ $RES_HIST -eq $QCOUNT ]]; then
		echo "$arg" > ~/.bash_history
	fi
}

# Expect args to exist
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
		if grep -Fxq "${args_array[$i]}" "$hist_file" || grep -Fxq "${args_array[$i]}/" "$hist_file" || grep -Fxq "${args_array[$i]} " "$hist_file"
		then
			# found_arg="${args_array[$i]}"
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
		response "$1" $COUNT
	else 
		tell_error "$1" $COUNT
	fi
}

function expect_directory
{
	if [[ -d "$1" ]]; then
		response "$1" $COUNT
	else 
		tell_error "$1" $COUNT
	fi
}

function expect_no_file 
{
	if [[ ! -f "$1" ]]; then
		response "$2" $COUNT
	else 
		tell_error "$2" $COUNT
	fi
}

function expect_no_directory
{
	if [[ ! -d "$1" ]]; then
		response "$2" $COUNT
	else 
		tell_error "$2" $COUNT
	fi
}

function expect_files
{
	args_array=()
	for (( i = 1; i <= $#; i++ )); do
		args_array[i]=${!i}
		found_arg="${args_array[$i]}"
		if [[ $i -le $# && -f "${args_array[$i]}" ]]; then
			echo -e "[Correct] Task $COUNT. ${found_arg}"
		else
			echo -e "[Missing] Task $COUNT. Expected: ${found_arg}"
		fi
	done
	test_command
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

function expect_file_match {
	if [[ ! -f "$2" ]]; then
		echo -e "[Missing] Task $COUNT. Expected: Missing file in right directory."
		return 1
	fi
	if ! grep -qFxvf "$2" "$3"
	then
		response "$1" $COUNT
	else 
		tell_error "$1" $COUNT
	fi
}

# Error and response
function tell_error 
{
	echo -e "[Error  ] Task $2. Expected: ${1}. Try again."
	return 1
	test_command
}

function response 
{
	echo -e "[Correct] Task $2. ${1}"
	(( RES_HIST ++ ))
	test_command
}

# Run test
function test_command {
	(( COUNT ++ ))
	if [[ $COUNT -le $QCOUNT ]]; then
		case $COUNT in
			1 )
				# expect_file_match "In your ~/workspace directory. Find with directory -maxdepth of 1 only file name type that begin with the letter h and redirect the output to a ~/workspace/project-log/files-with-h.txt file" "$BASHDIR/workspace-cli4/project-log/files-with-h.txt" "$BASHDIR/bashtests/CLI4/project-log-test/files-with-h.txt"
				expect_file_match "In your ~/workspace directory. Find with directory -maxdepth of 1 only file name type that begin with the letter h and redirect the output to a ~/workspace/project-log/files-with-h.txt file" "/home/codio/workspace/project-log/files-with-h.txt" "$BASHDIR/bashtests/project-log-test/files-with-h.txt"
				;;
			2 )
				expect_command "find . -path \"*.txt\"" "Find all the .txt files while being in the ~/workspace/project-log directory"
				;;
		esac
	else 
		return 0
		reset_history
	fi
}


test_command