#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-15s\n' "Criar usuario de teste" ; tput sgr0
echo ""
mkdir /etc/usuariosteste 1>/dev/null 2>/dev/null
echo -e "   Usuarios teste"
for testus in $(ls /etc/usuariosteste |sort |sed 's/.sh//g')
do
echo "$testus"
done
printf "\n"
printf "Nome do novo usuario: "; read nome
printf "Senha do usuario: "; read pass
echo -e "\nUse s = segundos, m = minutos, h = horas e d = dias EX: 14s ."
printf "Quanto tempo usuario $nome deve durar: ";read tempoin
tempo=$(echo "$tempoin" |sed 's/ //g')
useradd -M -s /bin/false $nome
(echo $pass;echo $pass) |passwd $nome 1>/dev/null 2>/dev/null
echo "#!/bin/bash
sleep $tempo
kill"' $(ps -u '"$nome |awk '{print"' $1'"}') 1>/dev/null 2>/dev/null
userdel --force $nome
rm -rf /etc/usuariosteste/$nome.sh
exit" > /etc/usuariosteste/$nome.sh
echo -e "Usuario: $nome
Senha: $pass
Validade: $tempo\n
Apos o tempo expirar o usuario sera deletado e todos serão desconectados."
bash /etc/usuariosteste/$nome.sh &
exit