#!/bin/bash
# bash_history edit

bash_history=~/.bash_history
check_file=cli-1-2.txt
grep -A2000 -e "^cli-1-2" $bash_history > "$BASHDIR/bashtests/CLI1/$check_file"

hist_file="$BASHDIR/bashtests/CLI1/$check_file"

QCOUNT=2
function expect_command 
{
	(( QCOUNT -- ))
	if grep -Fxq "$1" "$hist_file"
	then
		response "$1" "$3" $QCOUNT
	else 
		tell_error "$1" "$2" $QCOUNT
	fi
}

function tell_error 
{
	echo "You are missing task $(( $3 + 1 )) command right. Expected: $2. Try again."
	return 1
	exit
}

function response 
{
	echo "$(($3+1)). The '$1' command $2"
	test_command
}

function test_command {
	while [[ $QCOUNT > 0 ]]; do
		case $QCOUNT in
			1 )
				expect_command "ls" "list files and directories" "lists files and directories"
				;;
			2 )
				expect_command "ls -a" "list hidden files and directories" "together with the '-a' option lists hidden files and directories"
				;;
		esac
	done
}


test_command