#!/bin/bash


function startup() {
	mkdir -p simplemail
	mkdir -p simplemail/Users
	touch simplemail/userlist
	touch simplemail/passwdlist
}

function createuser() {
	if [ $(grep -i -c -w "$1" simplemail/userlist) -gt 0 ]; then
		echo Erro: Nome de Usuário indisponível.
	else
		echo $1 >> simplemail/userlist
		echo $2 >> simplemail/passwdlist
	fi
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
				if [ ! "$arg3" == "" ]; then
					echo "Erro: Mais de dois parâmetros como input; Uso: createuser <nome> <senha>"
				else
					if [ ${#arg1} -lt 4 ] || [ ${#arg2} -lt 4 ]; then
						echo "Erro: Usuário e senha devem ter, no mínimo, 4 caracteres."
					else
						createuser $arg1 $arg2
					fi
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
