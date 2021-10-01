#!/bin/bash

function createuser() {
	
	echo username: $1
	echo password: $2
}


function main() {

	startup
	while [ true ]; do
		read -p "simplemail> " command arg1 arg2 arg3

		if [ "$command" = quit ]; then
			exit
		fi
	done
}

main