# BASHTESTS Funcs

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
		test_command
	else 
		tell_error "$2" $COUNT
	fi
}

function expect_directory
{
	if [[ -d "$1" ]]; then
		test_command
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

function expect_no_file 
{
	if [[ ! -f "$1" ]]; then
		test_command
	else 
		tell_error "$2" $COUNT
	fi
}

function expect_no_directory
{
	if [[ ! -d "$1" ]]; then
		test_command
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

function expect_directories
{
	args_array=()
	for (( i = 1; i <= $#; i++ )); do
		args_array[i]=${!i}
		found_arg="${args_array[$i]}"
		if [[ $i -le $# && ! -d "${args_array[$i]}" ]]; then
			echo -e "[Missing] Task $COUNT. Expected: ${found_arg}"
			return 1
		fi
	done
	test_command
}

function expect_file_match 
{
	if [[ ! -f "$2" ]]; then
		echo -e "[Missing] Task $COUNT. Expected: Missing file in right directory."
		return 1
	fi
	if ! grep -qFxvf "$2" "$3"
	then
		test_command
	else 
		tell_error "$1" $COUNT
	fi
}

function expect_permissions 
{
	if [[ -f "$3/$1" || -d "$3/$1" ]]; then
		file_details=$(ls -alh "$3" | grep "$1")
		echo "$file_details" >> "$hist_file"
		if grep --q "^$2" "$hist_file"
		then
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

function tell_error 
{
	echo -e "[Error  ] Task $2. Expected: ${1}. Try again."
	return 1
}

export -f expect_command 
export -f expect_commands 
export -f expect_file 
export -f expect_directory
export -f expect_no_file 
export -f expect_no_directory
export -f expect_files
export -f expect_directories
export -f expect_file_match
export -f expect_permissions
export -f tell_error 