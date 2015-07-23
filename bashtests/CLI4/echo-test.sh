#!/bin/bash
# echo-test

# Vars group
# Points
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

PROMPT="${COLRESET}codio ~/workspace/project-log $ ${COLRESET}"

# Helper funcs
function addpoints {
	totalpoints=$(($totalpoints+$pospoints))
	echo "${PROMPTCOLOR}=>${QCOLOR} Totalpoints: $totalpoints ${COLRESET}"
}
function substractpoints {
	totalpoints=$(($totalpoints-$negpoints))
	echo "${PROMPTCOLOR}=>${QCOLOR} Totalpoints: $totalpoints ${COLRESET}"
}
function changedir {
	cd "$1"
}

function goodbye {
	echo -e "\n"
	# echo "${PROMPTCOLOR}=>${QCOLOR} The ${CMDCOLOR}mv${QCOLOR} command can also be used to update files and directories' names.${COLRESET}"
	addpoints
	echo "${PROMPTCOLOR}=>${QCOLOR} Keep on going with the CLI course, see you next time!${COLRESET}"
	exit
}

function question1 {
	if [[ $(pwd) != "/Volumes/Seagate Backup Plus Drive/htdocs/Bash/workspace-cli4/project-log" ]]; then
		changedir "$BASHDIR/workspace-cli4/project-log"
	fi
	# if [[ $(pwd) != "/home/codio/workspace/project-log" ]]; then
	# 	changedir ~/workspace/project-log
	# fi
	find . -path "*.txt" -delete
	echo "${PROMPTCOLOR}TASK: ${QCOLOR}Print the text: ${OUTCOLOR}'Changelog: '${QCOLOR} to the ${OUTCOLOR}stdout${QCOLOR}:${COLRESET}"
	echo -n "${PROMPT}"
	read -r qa1
	if [[ $qa1 =~ (^echo \'Changelog: ?\') || $qa1 =~ (^echo \"Changelog: ?\") ]]; then
		echo 'Changelog: '
		sleep 1
		echo "${PROMPTCOLOR}=> ${ANSCOLOR}Cool! The ${OUTCOLOR}stdout${ANSCOLOR} by default is the CLI itself. Lets proceed.${COLRESET}"
		addpoints
		about_string_interpolation
	else
		echo "${PROMPTCOLOR}ERROR: ${ERRCOLOR}The ${CMDCOLOR}$qa1${COLRESET}${ERRCOLOR} command will not print the requested string. Check your grammar and casing.${COLRESET}"
		substractpoints
		question1
	fi
}

function about_string_interpolation {
	echo -e "\n"
	echo -n "${PROMPTCOLOR}=> ${ANSCOLOR}It is possible to insert the output of a bash command within the text string that's being echoed. (press enter)${COLRESET}"
	read -r key_press
	echo -n "${PROMPTCOLOR}=> ${ANSCOLOR}This is known as ${OUTCOLOR}string interpolation${ANSCOLOR} and has a very basic syntax:${COLRESET}"
	read -r key_press
	echo -n "${PROMPTCOLOR}=> ${ANSCOLOR}For example, to write down the ${CMDCOLOR}pwd${ANSCOLOR} command within a string, you'll execute:${COLRESET}"
	read -r key_press
	echo -n "${PROMPTCOLOR}=> ${CMDCOLOR}echo \"Path to current directory: \$(pwd)\" ${ANSCOLOR}where the output would be:${COLRESET}"
	read -r key_press
	echo -n "${PROMPTCOLOR}=> ${OUTCOLOR}Path to current directory: $(pwd)${COLRESET}"
	read -r key_press
	echo -n "${PROMPTCOLOR}=> ${ANSCOLOR}Lets apply this knowledge - (press enter)${COLRESET}"
	read -r key_press
	question2
} 

function question2 {
	echo -e "\n"
	echo "${PROMPTCOLOR}TASK: ${QCOLOR}Write the text: ${OUTCOLOR}\"Changelog: \$TODAYS_DATE\\nVersion: 1.0\\n\"${QCOLOR} where ${OUTCOLOR}\$TODAYS_DATE${QCOLOR} is a ${CMDCOLOR}date${QCOLOR} command string interporlation and redirect the ${OUTCOLOR}stdout${QCOLOR} to be a ${OUTCOLOR}changelog.txt${QCOLOR} file:${COLRESET}"
	echo -n "${PROMPT}"
	read -r qa2
	if [[ ! $qa2 =~ (-e) ]]; then
		echo "${PROMPTCOLOR}ERROR: ${ERRCOLOR}The ${CMDCOLOR}$qa2${COLRESET}${ERRCOLOR} command is missing the option to not take the special characters literally. Try again.${COLRESET}"
		substractpoints
		question2
	elif [[ $qa2 =~ (^echo -e \"Changelog: ?\$\(date\)\\n ?Version: ?1.0\\n\" > changelog.txt) || $qa2 =~ (^echo -e \'Changelog: ?\$\(date\)\\nVersion: ?1.0\\n\' > changelog.txt) ]]; then
		echo -e "Changelog: $(date)\nVersion: 1.0\n" > changelog.txt
		sleep 1
		echo "${PROMPTCOLOR}=> ${ANSCOLOR}All right! There's a new ${OUTCOLOR}~/workspace/project-log/changelog.txt${ANSCOLOR} file.${COLRESET}"
		echo "${PROMPTCOLOR}=> ${ANSCOLOR}The content looks like this:${COLRESET}"
		cat changelog.txt
		goodbye
	else
		echo "${PROMPTCOLOR}ERROR: ${ERRCOLOR}The ${CMDCOLOR}$qa2${COLRESET}${ERRCOLOR} command will not echo the requested string to the requested file. Mind the double quotes, the line breaks and the casing.${COLRESET}"
		substractpoints
		question2
	fi
}













question1