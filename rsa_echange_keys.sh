#!/bin/bash
 
BACKUPUSER=$1
PC_TARGET=$2
port_ssh=$3
#Configuring the ssh connection.
#We need to send the rsa key to the remote account
ssh -p $3 $BACKUPUSER@$PC_TARGET 'test -d $HOME/.ssh'
R=$?

if [ $R = 0 ]
	then
		echo "OK d"
		ssh -p $3 $BACKUPUSER@$PC_TARGET 'test -f $HOME/.ssh/authorized_keys'
		R2=$?
		if [ $R2 = 0 ]
			then
				echo "OK f"
			else
				echo "création du fichier"
				ssh -p $3 $BACKUPUSER@$PC_TARGET 'touch $HOME/.ssh/authorized_keys'
		fi
	else
		echo "création du repertoire et du fichier"
		ssh -p $3 $BACKUPUSER@$PC_TARGET 'mkdir -p $HOME/.ssh'
		ssh -p $3 $BACKUPUSER@$PC_TARGET 'touch $HOME/.ssh/authorized_keys'
fi
cat $HOME/.ssh/id_rsa.pub|ssh -p $3 $BACKUPUSER@$PC_TARGET "cat >> .ssh/authorized_keys ; chmod 600 .ssh/authorized_keys"