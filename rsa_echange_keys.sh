#!/bin/bash

# input variable 

BACKUPUSER=$1
PC_TARGET=$2
port_ssh=$3
password=$4

# vérification des entrées
if [[ $# -eq 0 ]] ; then
    echo 'remote user'
    read BACKUPUSER
    echo 'ip distante'
    read PC_TARGET
    echo 'port ssh (defaut 22)'
    read port_ssh
    echo 'mot de passe'
    read password
fi
sshpass -p $password ssh -p $3 $BACKUPUSER@$PC_TARGET 'test -d $HOME/.ssh'
R=$?

if [ $R = 0 ]
	then
		echo "OK d"
		sshpass -p $password ssh -p $3 $BACKUPUSER@$PC_TARGET 'test -f $HOME/.ssh/authorized_keys'
		R2=$?
		if [ $R2 = 0 ]
			then
				echo "OK f"
			else
				echo "création du fichier"
				sshpass -p $password ssh -p $3 $BACKUPUSER@$PC_TARGET 'touch $HOME/.ssh/authorized_keys'
		fi
	else
		echo "création du repertoire et du fichier"
		sshpass -p $password ssh -p $3 $BACKUPUSER@$PC_TARGET 'mkdir -p $HOME/.ssh'
		sshpass -p $password ssh -p $3 $BACKUPUSER@$PC_TARGET 'touch $HOME/.ssh/authorized_keys'
fi
cat $HOME/.ssh/id_rsa.pub|sshpass -p $password ssh -p $3 $BACKUPUSER@$PC_TARGET "cat >> .ssh/authorized_keys ; chmod 600 .ssh/authorized_keys"
