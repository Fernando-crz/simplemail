#!/bin/bash


function startup() {
	mkdir -p simplemail
	mkdir -p simplemail/Users
	touch simplemail/userlist
	touch simplemail/passwdlist
}

function createuser() {
	
	echo username: $1
	echo password: $2
}

function passwd() {
	echo $1
	echo $2
	echo $3
}

function login() {
	echo login!
}

function main() {

	startup
	while [ true ]; do
		read -p "simplemail> " command arg1 arg2 arg3

		case $command in

			quit)
				exit
				;;
		esac
	done
}

main
