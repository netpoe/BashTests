#!/bin/bash
# echo test

bash_history=~/.bash_history
# BASHDIR=/home/codio/workspace/.guides
check_file=cli-7-1
hist_file="$BASHDIR/bashtests/CLI7/$check_file.txt"

echo "$check_file" >> $bash_history
grep -A2000 -e "^$check_file" $bash_history > "$BASHDIR/bashtests/CLI7/${check_file}.txt"

# Must match for erasing history
RES_HIST=0
COUNT=0
QCOUNT=3

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
		# if grep -FxE "${args_array[$i]}" "$hist_file"
		if grep -Fxqe "${args_array[$i]}" "$hist_file" || grep -Fxqe "${args_array[$i]}/" "$hist_file" || grep -Fxqe "${args_array[$i]} " "$hist_file" || grep -FxE "${args_array[$i]}" "$hist_file"
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

function expect_permissions {
	if [[ -f "$3/$1" || -d "$3/$1" ]]; then
		file_details=$(ls -alh "$3" | grep "$1")
		echo "$file_details" >> "$hist_file"
		if grep --q "^$2" "$hist_file"
		then
			echo -e "[Correct] Task $COUNT. item '$1' matches requested permissions: $2"
			test_command
		else
			echo -e "[Error  ] Task $COUNT. item '$1' does not match requested permissions: $2"
			return 1
		fi
	else
		echo -e "[Error  ] Task $COUNT. file or directory not in the current directory"
		return 1
	fi
}

# Error and response
function tell_error 
{
	echo -e "[Error  ] Task $2. Expected: ${1}. Try again."
	return 1
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
				expect_command "export curr_user=\$(whoami)" "Export a variable called 'curr_user' that holds the value of the 'whoami' command"
				;;
			2 )
				expect_command "bash" "Start a new child shell"
				;;
			3 )
				expect_command "echo \$curr_user" "Echo the curr_user variable on it"
				;;
		esac
	else 
		# reset_history
		return 0
	fi
}


test_command