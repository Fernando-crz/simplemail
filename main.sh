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

			createuser)
				if [ "$arg3" == "" ]; then
					echo "Erro: Mais de dois parametros como input; Uso: createuser <nome> <senha>"
				else
					createuser $arg1 $arg2
				fi
				;;

			quit)
				echo OK, até mais!
				exit
				;;
		esac
	done
}

main
