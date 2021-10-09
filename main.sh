#!/bin/bash




function startup() {
	rm -f simplemail/.userauth
	mkdir -p simplemail
	mkdir -p simplemail/Users
	>> simplemail/userlist
	>> simplemail/passwdlist
	echo '     _______. __  .___  ___. .______    __       
    /       ||  | |   \/   | |   _  \  |  |     |   ____|
   |   (----`|  | |  \  /  | |  |_)  | |  |     |  |__   
    \   \    |  | |  |\/|  | |   ___/  |  |     |   __|  
.----)   |   |  | |  |  |  | |  |      |  `----.|  |____ 
|_______/    |__| |__|  |__| | _|      |_______||_______|
                                                         
	   .___  ___.      ___       __   __                     
	   |   \/   |     /   \     |  | |  |                    
	   |  \  /  |    /  ^  \    |  | |  |                    
	   |  |\/|  |   /  /_\  \   |  | |  |                    
	   |  |  |  |  /  _____  \  |  | |  `----.               
	   |__|  |__| /__/     \__\ |__| |_______|               
                                                         '

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
		PASS=$(sed "$USERNUM q;d" simplemail/passwdlist)
		if [ "$2" != "$PASS" ]; then
			echo "Erro: Senha incorreta."
		else
			echo $1 > simplemail/.userauth
		fi
		unset USERNAME USERNUM PASS
	fi


}

function listusers() {
	if [ $(checkauth) == 1 ]; then
		cat simplemail/userlist
	else
		echo "Erro: Usuário não logado."
	fi
}

function msg(){

	if [ $(checkauth) == 1 ]; then
		if [ $(grep -i -c -o "\b$1\b" simplemail/userlist) -le 0 ]; then
			echo "Erro: Nome de Usuário inexistente."
		else
			echo "Qual assunto da mensagem?"
			read SUBJECT
			let NAME=$(cat ./simplemail/Users/$1/msginfo)+1
			echo "Qual a mensagem? Termine com \"CRTL-D\" "
			echo -e "1\n$(date)\n$(cat simplemail/.userauth)\n$SUBJECT" > ./simplemail/Users/$1/$NAME
			cat >> ./simplemail/Users/$1/$NAME
			echo $NAME > ./simplemail/Users/$1/msginfo

		fi
		unset SUBJECT NAME
	else
		echo "Erro: Usuário não logado" 
	fi

		

}

function list() {
	if [ $(checkauth) == 1 ]; then

		USER=$(cat simplemail/.userauth)
		CONT=1

		for ARQ in `ls ./simplemail/Users/$USER/`; do
			
			if [ ! $ARQ == "msginfo" ]; then

				READ=" "
				if [ $(head -n 1 ./simplemail/Users/$USER/$ARQ) == 1 ]; then
					READ="N"
				fi
				echo "$CONT | $READ | $(sed '2q;d' ./simplemail/Users/$USER/$ARQ) | $(sed '3q;d' ./simplemail/Users/$USER/$ARQ) | Assunto: $(sed '4q;d' ./simplemail/Users/$USER/$ARQ)"
			fi
			((CONT++))
		done

		unset CONT USER
	else
		echo "Erro: Usuário não logado"
	fi
}


function readmail() {

	if [ $(checkauth) == 1 ]; then

		USER=$(cat simplemail/.userauth)
		NUM=$1
		CONT=1
		NUMBERMAIL=$(ls ./simplemail/Users/$USER/ | wc -w)

		if [ $NUM -lt $NUMBERMAIL ]; then
			for ARQ in `ls ./simplemail/Users/$USER/`; do

				if [ $NUM == $CONT ]; then

					echo "De: $(sed '3q;d' ./simplemail/Users/$USER/$ARQ)"
					echo "$(sed -n '5,$p' ./simplemail/Users/$USER/$ARQ)"
					sed -i '1s/.*/0/' ./simplemail/Users/$USER/$ARQ
					break
					
				fi
				
				
				((CONT++))
			done
		else
			echo "Numero de mensagem inexistente"
		fi
		
		unset CONT USER USERNUM		

	else
		echo "Erro: Usuário não logado"
	fi

}

function unread() {

	if [ $(checkauth) == 1 ]; then

		USER=$(cat simplemail/.userauth)
		NUM=$1
		CONT=1
		NUMBERMAIL=$(ls ./simplemail/Users/$USER/ | wc -w)

		if [ $NUM -lt $NUMBERMAIL ]; then
			for ARQ in `ls ./simplemail/Users/$USER/`; do

				if [ $NUM == $CONT ]; then

					sed -i '1s/.*/1/' ./simplemail/Users/$USER/$ARQ
					break
					
				fi
				
				
				((CONT++))
			done
		else
			echo "Numero de mensagem inexistente"
		fi
		
		unset CONT USER USERNUM		

	else
		echo "Erro: Usuário não logado"
	fi

}

function delete(){

	if [ $(checkauth) == 1 ]; then

		USER=$(cat simplemail/.userauth)
		NUM=$1
		CONT=1
		NUMBERMAIL=$(ls ./simplemail/Users/$USER/ | wc -w)

		if [ $NUM -lt $NUMBERMAIL ]; then
			for ARQ in `ls ./simplemail/Users/$USER/`; do

				if [ $NUM == $CONT ]; then

					rm -f ./simplemail/Users/$USER/$ARQ
					break
					
				fi
				
				
				((CONT++))
			done
		else
			echo "Numero de mensagem inexistente"
		fi
		
		unset CONT USER USERNUM		

	else
		echo "Erro: Usuário não logado"
	fi
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
			msg)
				if [ ! "$arg2" == "" ]; then
					echo "Erro: Mais de um parâmetro como input; Uso: msg <user>"
				else
					msg $arg1
				fi
				;;
			list)
				if [ ! "$arg1" == "" ]; then
					echo "Erro: Parâmetro desnecessário como input; Uso: list"
				else
					list
				fi
				;;
			read)
				if [ ! "$arg2" == "" ]; then
					echo "Erro: Mais de um parâmetro como input; Uso: read <msgnum>"
				else
					readmail $arg1
				fi
				;;
			unread)
				if [ !"$arg2" == "" ]; then
					echo "Erro: Mais de um parâmetro como input; Uso: unread <msgnum>"
				else
					unread $arg1
				fi
				;;
			delete)
				if [ !"$arg2" == "" ]; then
					echo "Erro: Mais de um parâmetro como input; Uso: delete <msgnum>"
				else
					delete $arg1
				fi
				;;
			quit)
				echo OK, até mais!
				rm -f simplemail/.userauth
				exit
				;;
			*)
				echo "Erro: Comando Inexistente."
				;;
		esac
	done
}

main
