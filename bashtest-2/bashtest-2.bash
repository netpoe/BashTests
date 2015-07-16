#!bin/bash

totalpoints=1
pospoints=2
negpoints=1

# Colors
ERRCOLOR=`tput setaf 1`
QCOLOR=`tput setaf 3`
ANSCOLOR=`tput setaf 2`
OUTCOLOR=`tput setaf 4`
PROMPTCOLOR=`tput setaf 3`
CMDCOLOR=`tput setaf 4`
COLRESET=`tput sgr0`

# Helper funcs
saidgreetings=0
function greetings {
	echo "${PROMPTCOLOR}=>${ANSCOLOR}All right ${OUTCOLOR} $username!${ANSCOLOR} Lets begin!"
	saidgreetings=1
	question1
}

function begintest {
	if [[ -d "assets" || -d "css" || -d "js" ]]; then
		# Remove all directories and files except .guides
		find . -type d -not -name .guides -not -name .gitignore -not -name .settings -not -name .git -exec rm -r {} \;
		clear
	fi
	echo "${PROMPTCOLOR}=>${QCOLOR} Woops! The terminal erased all the files and directories we've had already created!"
	echo "${PROMPTCOLOR}=>${QCOLOR} Challenge the terminal by creating the files and directories as we just learned."
	echo -n "${PROMPTCOLOR}=>${QCOLOR} Are you ready? [yes/no]:"
	read -r response
	if [[ "$response" == "yes" ]]; then
		echo "${PROMPTCOLOR}=>${QCOLOR} Excellent, choose a username:"
		read -r username
		greetings
		question1
	else
		echo "${PROMPTCOLOR}=>${ERRCOLOR} Uhm, I can wait until you type 'yes'"
		begintest
	fi
}






begintest