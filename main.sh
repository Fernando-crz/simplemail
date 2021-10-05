#!/bin/bash


function startup() {
	mkdir -p simplemail
	mkdir -p simplemail/Users
	> simplemail/userlist
	> simplemail/passwdlist
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
	USERNAME=$(grep -n -w -i $1 simplemail/userlist)
	if [ "$USERNAME" == "" ]; then
		echo "Erro: Usuário inexistente."
	else
		USERNUM=${USERNAME%:*}
		PASS=$(head -n $USERNUM simplemail/passwdlist | tail -1)
		if [ $2 != $PASS ]; then
			echo "Erro: Senha incorreta."
		else
			echo $1 > simplemail/.userauth
		fi
	fi


}

function listusers() {
	cat simplemail/userlist
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

			listusers)
				if [ ! "$arg1" == "" ] || [ ! "$arg2" == "" ] || [ ! "$arg3" == "" ]; then
					echo "Erro: função não recebe parâmetros; Uso: listusers"
				else
					listusers
				fi
				;;

			login)
				if [ ! "$arg3" == "" ]; then
					echo "Erro: Mais de dois parâmetros como input; Uso: login <nome> <senha>"
				else
					login $arg1 $arg2
				fi
				;;

			quit)
				echo OK, até mais!
				rm -f simplemail/.userauth
				exit
				;;
		esac
	done
}

main
