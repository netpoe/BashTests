#!/bin/bash
# touch test

bash_history=~/.bash_history
#BASHDIR=/home/codio/workspace/.guides
check_file=cli-2-2
hist_file="$BASHDIR/bashtests/CLI2/$check_file.txt"

echo "$check_file" >> $bash_history
grep -A2000 -e "^$check_file" $bash_history > "$BASHDIR/bashtests/CLI2/${check_file}.txt"
find "$hist_file" -type f -exec sed -i "s@~@$HOME@g" {} \; 

# Must match for erasing history
RES_HIST=0
COUNT=0
QCOUNT=3

function expect_command 
{
	if grep -Fxq "$1" "$hist_file"
	then
		test_command
	else 
		tell_error "$2" $COUNT
	fi
}

function expect_commands 
{
	args_array=()
  found_arg=false
	for (( i = 2; i <= $#; i++ )); do
		args_array[i]=${!i}
	done
	for (( i = 2; i <= $#; i++ )); do
		arg=$( sed -e "s@~@$HOME@g" <<< "${args_array[$i]}" )
		if grep -Fxqe "$arg" "$hist_file" || grep -Fxqe "$arg/" "$hist_file" || grep -Fxqe "$arg " "$hist_file" || grep -Fxqe "$arg/ " "$hist_file"
    then
      found_arg=true
      break
    fi
	done
  if $found_arg
  then
      test_command
  else
      tell_error "$1" $COUNT
  fi
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

function expect_files
{
	args_array=()
	for (( i = 1; i <= $#; i++ )); do
		args_array[i]=${!i}
		found_arg="${args_array[$i]}"
		if [[ $i -le $# && ! -f "${args_array[$i]}" ]]; then
      echo -e "[Missing] Task $COUNT. Expected: ${found_arg}"
      return 1
		fi
	done
  test_command
}

function tell_error 
{
	echo -e "[Error  ] Task $2. Expected: ${1}. Try again."
	return 1
}

function test_command {
	(( COUNT ++ ))
	if [[ $COUNT -le $QCOUNT ]]; then
		case $COUNT in
			1 )
				# expect_files "/home/codio/workspace/test-website/index.html" "/home/codio/workspace/test-website/.website-config" "/home/codio/workspace/test-website/css/styles.css" "/home/codio/workspace/test-website/img/logo.png" "/home/codio/workspace/test-website/js/scripts.js"
				expect_files "$BASHDIR/workspace-cli2/test-website/index.html" "$BASHDIR/workspace-cli2/test-website/.website-config" "$BASHDIR/workspace-cli2/test-website/css/styles.css" "$BASHDIR/workspace-cli2/test-website/img/logo.png" "$BASHDIR/workspace-cli2/test-website/js/scripts.js"
				;;
			2 )
				expect_commands "list test-website/css directory from ~/workspace folder" "ls test-website/css" "ls test-website/css/" "ls ~/workspace/test-website/css/" "ls ~/workspace/test-website/css"
				;;
			3 )
				expect_command "clear" "clear terminal screen"
				;;
		esac
	else 
		echo -e "Well done!"
		return 0
	fi
}


test_command