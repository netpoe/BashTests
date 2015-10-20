#!/bin/bash
# touch test

bash_history=~/.bash_history
# BASHDIR=/home/codio/workspace/.guides
check_file=cli-2-3
hist_file="$BASHDIR/bashtests/CLI2/$check_file.txt"

echo "$check_file" >> $bash_history
grep -A2000 -e "^$check_file" $bash_history > "$BASHDIR/bashtests/CLI2/${check_file}.txt"

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

function expect_command 
{
	if grep -Fxq "$1" "$hist_file"
	then
		response "$2" $COUNT
	else 
		tell_error "$2" $COUNT
	fi
}

# function expect_commands 
# {
# 	args_array=()
# 	for (( i = 2; i <= $#; i++ )); do
# 		# args_array[i]=${!i}
# 		if grep -Fxqe "${args_array[$i]}" "$hist_file" || grep -Fxq "${args_array[$i]}/" "$hist_file" || grep -Fxq "${args_array[$i]} " "$hist_file" || grep -Fxqe "${args_array[$i]}" "$hist_file"
# 		then
# 			response "$1" $COUNT
# 		else
# 			tell_error "$1" $COUNT
# 		fi
# 	done
# }
function expect_commands 
{
	args_array=()
	for (( i = 2; i <= $#; i++ )); do
		args_array[i]=${!i}
		arg=$( sed "s/ ~/ $HOME/g" <<< "${args_array[$i]}" )    # translate ~ to $HOME
		if grep -Fxq -e "$arg" -e "$arg/" -e "$arg " "$HISTFILE"
		then
			response "$1" $COUNT
		else
			tell_error "$1" $COUNT
		fi
	done
}

# function expect_commands {
#     local label=$1
#     shift
#     for arg do
#         arg=$( sed "s/ ~/ $HOME/g" <<< "$arg" )    # translate ~ to $HOME
#         if grep -Fxq -e "$arg" -e "$arg/" -e "$arg " "$HISTFILE"
#         then
#             response "$label" $COUNT
#         else
#             tell_error "$label" $COUNT
#         fi
#     done
# }

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

function test_command {
	(( COUNT ++ ))
	if [[ $COUNT -le $QCOUNT ]]; then
		case $COUNT in
			1 )
				expect_no_file "/home/codio/workspace/test-website/js/scripts.js" "remove ~/workspace/test-website/js/scripts.js file"
				;;
			2 )
				expect_no_directory "/home/codio/workspace/test-website/js" "remove empty ~/workspace/test-website/js directory"
				;;
			3 )
				expect_commands "remove entire ~/workspace/test-website/css directory" "rm -r test-website/css" "rm -r test-website/css/" "rm -Rf ~/workspace/test-website/css"
				;;
		esac
	else 
		# reset_history
		return 0
	fi
}


test_command