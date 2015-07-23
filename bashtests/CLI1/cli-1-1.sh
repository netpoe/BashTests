#!/bin/bash
# bash_history edit

bash_history=~/.bash_history
check_file=cli-1-1.txt
grep -A2000 -e "^cli-1-1" $bash_history > $check_file

check_file="$BASHDIR/bashtests/CLI1/$check_file"

q1=0
q2=0
q3=0
q4=0
q5=0
q6=0
q7=0
# if [[ $q1 -eq 1 && $q2 -eq 1 && $q3 -eq 1 && $q4 -eq 1 && $q5 -eq 1 && $q6 -eq 1 && $q7 -eq 1 ]]

function goodbye {
	if [[ $q1 -eq 1 && $q2 -eq 1 ]]; then
		echo "That's it! The 'whoami' command outputs the current logged in user: $(whoami)"
		echo "Our current directory path is $(pwd)"
		# return 1
	fi
}

function tell_error {
	case $1 in
		"qa1" )
			echo "1. Command does not output current user"
			;;
		"qa1" )
			echo "2. Command does not output current working directory path"
			;;
		* )
			exit 0
			;;
	esac
}

# Get the _current user_
function question1 {
	if grep -Fxq "whoami" "$check_file"
	then
		q1=1
		question2
	else
		tell_error "qa1"
	fi
}

# Print the _path to the working directory_
function question2 {
	if grep -Fxq "pwd" "$check_file"
	then
		q2=1
		goodbye
	else
		tell_error "qa2"
	fi
}









question1