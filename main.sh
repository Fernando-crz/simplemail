#!/bin/bash


function startup() {
	rm -f simplemail/.userauth
	mkdir -p simplemail
	mkdir -p simplemail/Users
	>> simplemail/userlist
	>> simplemail/passwdlist
}

function checkauth() {
	if [ -f simplemail/.userauth ]; then
		echo 1
	else
		echo 0
	fi
}

function createuser() {
	if [ $(grep -i -c -o "\b$1\b" simplemail/userlist) -gt 0 ]; then
		echo Erro: Nome de Usuário indisponível.
	else
		echo $1 >> simplemail/userlist
		echo $2 >> simplemail/passwdlist
		mkdir -p simplemail/Users/$1
		echo 0 > simplemail/Users/$1/msginfo
	fi
}

function passwd() {
	USERNAME=$(grep -n -o -i "\b$1\b" simplemail/userlist)
	if [ "$USERNAME" == "" ]; then
		echo "Erro: Usuário inexistente."
	else
		USERNUM=${USERNAME%:*}
		PASS=$(head -n $USERNUM simplemail/passwdlist | tail -1)
		if [ "$PASS" != "$2" ]; then
			echo "Erro: Senha incorreta."
		else
			instruction='c\'
			sed -i "$USERNUM $instruction$3" simplemail/passwdlist
		fi
		unset USERNAME USERNUM PASS instruction
	fi

}

function login() {
	USERNAME=$(grep -n -o -i "\b$1\b" simplemail/userlist)
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
		unset USERNAME USERNUM PASS
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

			passwd)
				if [ ${#arg3} -lt 4 ]; then
					echo "Erro: Senha deve conter, no mínimo, 4 caracteres."
				else
					passwd $arg1 $arg2 $arg3
				fi
				;;

			listusers)
				if [ ! "$arg1" == "" ] ; then
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
