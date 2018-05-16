#!/bin/bash
database="/root/usuarios.db"
echo $$ > /tmp/pids
while true
do
echo -e "\033[44;1;37m              SSHMonitor                "
echo -e "\033[44;1;37m Usuarios      Conexões      Vencimento \033[0m"
while read usline
do
user="$(echo $usline | cut -d' ' -f1)"
s2ssh="$(echo $usline | cut -d' ' -f2)"
if [ -z "$user" ] ; then
	echo "" > /dev/null
else
	ps x | grep $user[[:space:]] | grep -v grep | grep -v pts > /tmp/tmp8
	s1ssh="$(cat /tmp/tmp8 | wc -l)"
fi
expire=$(chage -l $user | grep -E "Account expires" | cut -d ' ' -f3-)
if [[ $expire == "never" ]] 2> /dev/null
then
	nunca="Nunca"
	printf '  %-30s%s\n' "$user" "Nunca" ; tput sgr0
else
	databr="$(date -d "$expire" +"%Y%m%d")"
	hoje="$(date -d today +"%Y%m%d")"
	if [ $hoje -ge $databr ]
	then
		datanormal="$(date -d"$expire" '+%d/%m/%Y')"
		printf '  %-30s%s' "$user" "$datanormal" ; tput setaf 1 ; tput bold ; echo " (Expirado)" ; tput setaf 3
		echo "exp" > /tmp/exp
	else
		datanormal="$(date -d"$expire" '+%d/%m/%Y')"
		
	fi
fi
detalhesdata=$(printf '%-12s' "$datanormal")
detalhes=$(printf ' %-16s' "$user")
detalheslim=$(printf '%-10s' "$s1ssh/$s2ssh")
echo -e "\E[1;33m$detalhes $detalheslim $detalhesdata \E[0m"
done < "$database"
echo ""
exit 1
done