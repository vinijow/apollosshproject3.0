#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%35s%s%-20s\n' "VPS Manager 3. Edição Especial Servidores S.A" ; tput sgr0
tput setaf 3 ; tput bold ; echo "" ; echo "Este script irÃ¡:" ; echo ""
echo "â— Instalar e configurar o proxy squid nas portas 80, 3128, 8080 e 8799" ; echo "  para permitir conexões SSH para este servidor"
echo "â— Configurar o OpenSSH para rodar nas portas 22 e 2466"
echo "â— Instalar um conjunto de scripts como comandos do sistema para o gerenciamento de usuários" ; tput sgr0
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
tput setaf 2 ; tput bold ; echo "	Termos de Uso" ; tput sgr0
echo ""
echo "Ao utilizar o 'VPS Manager 3.0' você concorda com os seguintes termos de uso:"
echo ""
echo "1. Você pode:"
echo "a. Instalar e usar o 'VPS Manager 3.0' no(s) seu(s) servidor(es)."
echo "b. Criar, gerenciar e remover um número ilimitado de usuários através desse conjunto de scripts."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "2. Você não pode:"
echo "a. Editar, modificar, compartilhar ou redistribuir (gratuitamente ou comercialmente)"
echo "esse conjunto de scripts sem autorização do desenvolvedor."
echo "b. Modificar ou editar o conjunto de scripts para fazer você parecer o desenvolvedor dos scripts."
echo ""
echo "3. Você aceita que:"
echo "a. O valor pago por esse conjunto de scripts não inclui garantias ou suporte adicional,"
echo "porêm o usuário poderá, de forma promocional e não obrigatÃ³ria, por tempo limitado,"
echo "receber suporte e ajuda para solução de problemas desde que respeite os termos de uso."
echo "b. O usuário desse conjunto de scripts Ã© o único resposável por qualquer tipo de implicação"
echo "Ã©tica ou legal causada pelo uso desse conjunto de scripts para qualquer tipo de finalidade."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
echo "4. Você concorda que o desenvolvedor não se responsabilizarémos pelos:"
echo "a. Problemas causados pelo uso dos scripts distribuÃ­dos sem autorização."
echo "b. Problemas causados por conflitos entre este conjunto de scripts e scripts de outros desenvolvedores."
echo "c. Problemas causados por edições ou modificações do cÃ³digo do script sem autorizaÃ§Ã£o."
echo "d. Problemas do sistema causados por programas de terceiro ou modificações/experimentações do usuário."
echo "e. Problemas causados por modificações no sistema do servidor."
echo "f. Problemas causados pelo usuário não seguir as instruções da documentacão do conjunto de scripts."
echo "g. Problemas ocorridos durante o uso dos scripts para obter lucro comercial."
echo "h. Problemas que possam ocorrer ao usar o conjunto de scripts em sistemas que não estão na lista de sistemas testados."
echo ""
tput setaf 3 ; tput bold ; read -n 1 -s -p "Aperte qualquer tecla para continuar..." ; echo "" ; echo "" ; tput sgr0
IP=$(wget -qO- ipv4.icanhazip.com)
read -p "Para continuar confirme o IP deste servidor: " -e -i $IP ipdovps
if [ -z "$ipdovps" ]
then
	tput setaf 7 ; tput setab 1 ; tput bold ; echo "" ; echo "" ; echo " Você não digitou o IP deste servidor. Tente novamente. " ; echo "" ; echo "" ; tput sgr0
	exit 1
fi
if [ -f "/root/usuarios.db" ]
then
tput setaf 6 ; tput bold ;	echo ""
	echo "Uma base de dados de usuários ('usuarios.db') foi encontrada!"
	echo "Deseja mantê-la (preservando o limite de conexÃµes simultâneas dos usuários)"
	echo "ou criar uma nova base de dados?"
	tput setaf 6 ; tput bold ;	echo ""
	echo "[1] Manter Base de Dados Atual"
	echo "[2] Criar uma Nova Base de Dados"
	echo "" ; tput sgr0
	read -p "Opção?: " -e -i 1 optiondb
else
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
echo ""
read -p "Deseja ativar a compresssao SSH (pode aumentar o consumo de RAM)? [s/n]) " -e -i n sshcompression
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "" ; echo "Aguarde a configuração automatica" ; echo "" ; tput sgr0
sleep 3
tput setaf 3 ; tput bold ; echo "Fazendo atualizações... Isso pode demorar um pouco. Aguarde..." ; tput sgr0
apt-get update -y 1> /dev/null 2> /dev/stdout
apt-get upgrade -y 1> /dev/null 2> /dev/stdout
tput setaf 7 ; tput setab 8 ; tput bold ; echo "" ; echo "Atualizando diretórios..." ; echo "" ; tput sgr0
sleep 3
apt-get dist-upgrade -y

tput setaf 1 ; tput bold ; echo "#Apagando comandos antigos...#" ; tput sgr0
rm /bin/logins 1> /dev/null 2> /dev/stdout
rm /bin/limitar 1> /dev/null 2> /dev/stdout
rm /bin/sshmonitor2 1> /dev/null 2> /dev/stdout
rm /bin/criarusuario /bin/expcleaner /bin/sshlimiter /bin/addhost /bin/listar /bin/sshmonitor /bin/ajuda /bin/openvpnsetup /bin/userbackup /bin/tcptweaker /bin/badvpnsetup /bin/otimizar /bin/speedtest 1> /dev/null 2> /dev/stdout
rm /root/ExpCleaner.sh /root/CriarUsuario.sh /root/sshlimiter.sh 1> /dev/null 2> /dev/stdout
sleep 3

tput setaf 3 ; tput bold ; echo "Instalando o squid3..." ; tput sgr0
apt-get install squid3 bc screen nano unzip dos2unix wget python-pip inxi -y
sleep 4
tput setaf 9 ; tput bold ; echo "Instalando o speedtest..." ; tput sgr0
pip install speedtest-cli 1> /dev/null 2> /dev/stdout
sleep 1

tput setaf 1 ; tput bold ; echo "Removendo o apache2..." ; tput sgr0
sleep 1 
killall apache2 > /dev/null
apt-get purge apache2 -y 1> /dev/null 2> /dev/stdout

tput setaf 2 ; tput bold ; echo "Liberando portas necessárias..." ; tput sgr0
sleep 1
if [ -f "/usr/sbin/ufw" ] ; then
	ufw allow 2466/tcp ; ufw allow 443/tcp ; ufw allow 80/tcp ; ufw allow 3128/tcp ; ufw allow 8799/tcp ; ufw allow 8080/tcp 1> /dev/null 2> /dev/stdout
fi
if [ -d "/etc/squid3/" ]
then
        tput setaf 3 ; tput bold ; echo "Configurando o squid3..." ; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/squid1kt.txt -O /tmp/sqd1 1> /dev/null 2> /dev/stdout
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/squid2.txt -O /tmp/sqd3 1> /dev/null 2> /dev/stdout
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid3/squid.conf
        sleep 2
        tput setaf 6 ; tput bold ; echo "Configurando Hosts das payloads..." ; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/payload.txt -O /etc/squid3/payload.txt 1> /dev/null 2> /dev/stdout
	echo " " >> /etc/squid3/payload.txt

        tput setaf 4 ; tput bold ; echo "Configurando SSH na porta 22 e 2466" ; tput sgr0
	grep -v "^Port 2466 " /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	grep -v "^Port 443 " /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config
	echo "Port 2466" >> /etc/ssh/sshd_config
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config 
        sleep 2
        tput setaf 7 ; tput setab 4 ; tput bold ; echo "Preparando configuração dos comandos de gerenciamento de usuários. Por favor aguarde..." ; tput sgr0
        sleep 2
        tput setaf 3 ; tput bold ; echo "Adicionando comando addhost"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/addhost.sh -O /bin/addhost 1> /dev/null 2> /dev/stdout
	chmod +x /bin/addhost
        sleep 1
        tput setaf 5 ; tput bold ; echo "Adicionando comando alterarsenha"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/alterarsenha.sh -O /bin/alterarsenha 1> /dev/null 2> /dev/stdout
	chmod +x /bin/alterarsenha
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando criarusuario"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/criarusuario2.sh -O /bin/criarusuario 1> /dev/null 2> /dev/stdout
	chmod +x /bin/criarusuario
        sleep 1
        tput setaf 1 ; tput bold ; echo "Adicionando comando delhost"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/delhost.sh -O /bin/delhost 1> /dev/null 2> /dev/stdout
	chmod +x /bin/delhost
        sleep 1
        tput setaf 1 ; tput bold ; echo "Adicionando comando expcleaner"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/expcleaner2.sh -O /bin/expcleaner 1> /dev/null 2> /dev/stdout
	chmod +x /bin/expcleaner
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando mudardata"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/mudardata.sh -O /bin/mudardata 1> /dev/null 2> /dev/stdout
	chmod +x /bin/mudardata
        sleep 1
        tput setaf 1 ; tput bold ; echo "Adicionando comando expcleaner"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/remover.sh -O /bin/remover 1> /dev/null 2> /dev/stdout
	chmod +x /bin/remover
        sleep 1
        tput setaf 1 ; tput bold ; echo "Adicionando comando sshlimiter"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/sshlimiter2.sh -O /bin/sshlimiter 1> /dev/null 2> /dev/stdout
	chmod +x /bin/sshlimiter
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando alterarlimite"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/alterarlimite.sh -O /bin/alterarlimite 1> /dev/null 2> /dev/stdout
	chmod +x /bin/alterarlimite
        sleep 1
        tput setaf 2 ; tput bold ; echo "Adicionando comando ajuda"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/ajuda.sh -O /bin/ajuda 1> /dev/null 2> /dev/stdout
	chmod +x /bin/ajuda
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando sshmonitor"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/sshmonitor.sh -O /bin/sshmonitor 1> /dev/null 2> /dev/stdout
	chmod +x /bin/sshmonitor
        sleep 1
        tput setaf 2 ; tput bold ; echo "Adicionando comando badvpnsetup , para liberar chamada de WhatsApp,jogos e ETC.."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/badvpnsetup.sh -O /bin/badvpnsetup 1> /dev/null 2> /dev/stdout
	chmod +x /bin/badvpnsetup
        sleep 1
        tput setaf 4 ; tput bold ; echo "Adicionando comando tcptweaker, execulte para diminuir o ping do servidor.."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/tcptweaker.sh -O /bin/tcptweaker 1> /dev/null 2> /dev/stdout
	chmod +x /bin/tcptweaker
        sleep 2
        tput setaf 4 ; tput bold ; echo "Adicionando comando userbackup, para salvar todos os usuários criados..."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/userbackup.sh -O /bin/userbackup 1> /dev/null 2> /dev/stdout
	chmod +x /bin/userbackup
        sleep 2
        tput setaf 2 ; tput bold ; echo "Adicionando comando ovpn@servidoressa, para instalar o OpenVPN..."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/openvpnkt.sh -O /bin/ovpn@servidoressa 1> /dev/null 2> /dev/stdout
	chmod +x /bin/ovpn@servidoressa
        sleep 4
        tput setaf 2 ; tput bold ; echo "Adicionando comando otimizar, para fazer otimização do sistema..."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/otimizar.sh -O /bin/otimizar 1> /dev/null 2> /dev/stdout
	chmod +x /bin/otimizar
        sleep 3
        tput setaf 7 ; tput bold ; echo "Adicionando comando speedtest, para medir a velocidade do servidor."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/speedtest.sh -O /bin/speedtest 1> /dev/null 2> /dev/stdout
	chmod +x /bin/speedtest
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando detalhes, para ver as configurações do servidor..."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/detalhes.sh -O /bin/detalhes 1> /dev/null 2> /dev/stdout
	chmod +x /bin/detalhes
        sleep 1
        tput setaf 5 ; tput bold ; echo "Instalando comando limitar, para derrubar usuários que ultrapassam o limite a cada 5 minutos..." ; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/limitar.txt -O /bin/limitar 1> /dev/null 2> /dev/stdout
	chmod +x /bin/limitar
        sleep 2
        tput setaf 2 ; tput bold ; echo "Instalando comando logins, para ver quantos estão conectados..." ; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/logins.sh -O /bin/logins 1> /dev/null 2> /dev/stdout
	chmod +x /bin/logins
        sleep 2
        tput setaf 3 ; tput bold ; echo "Instalando comando sshmonitor2 para monitorar usuários (com data)..." ; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/sshmonitor2.sh -O /bin/sshmonitor2 1> /dev/null 2> /dev/stdout
        chmod +x /bin/sshmonitor2
        sleep 2
        tput setaf 6 ; tput bold ; echo "Instalando comando verdata para verificar a data de 1 unico usuário..." ; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/verdata.sh -O /bin/verdata 1> /dev/null 2> /dev/stdout
        chmod +x /bin/verdata
        sleep 2
        tput setaf 5 ; tput bold ; echo "Instalando comando criarteste , para criar usuários de teste de curto prazo..." ; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/criarteste.sh -O /bin/criarteste 1> /dev/null 2> /dev/stdout
        chmod +x /bin/criarteste
        sleep 2
        
	if [ ! -f "/etc/init.d/squid3" ]
	then
tput setaf 3 ; tput bold ; echo "Reiniciando o squid3..."; tput sgr0 
		service squid3 restart > /dev/null
	else
		/etc/init.d/squid3 restart > /dev/null
	fi
	if [ ! -f "/etc/init.d/ssh" ]
	then
       tput setaf 4 ; tput bold ; echo "Reiniciando o SSH..."; tput sgr0 
		service ssh restart > /dev/null
	else
		/etc/init.d/ssh restart > /dev/null
	fi
fi
if [ -d "/etc/squid/" ]
then
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/squid1kt.txt -O /tmp/sqd1
	echo "acl url3 dstdomain -i $ipdovps" > /tmp/sqd2
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/squid.txt -O /tmp/sqd3
	cat /tmp/sqd1 /tmp/sqd2 /tmp/sqd3 > /etc/squid/squid.conf
	tput setaf 6 ; tput bold ; echo "Configurando Hosts das payloads..." ; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/payload.txt -O /etc/squid3/payload.txt > /dev/null
	echo " " >> /etc/squid3/payload.txt 1> /dev/null 2> /dev/stdout

        tput setaf 4 ; tput bold ; echo "Configurando SSH..." ; tput sgr0
	grep -v "^Port 2466" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config > /dev/null
	grep -v "^Port 443" /etc/ssh/sshd_config > /tmp/ssh && mv /tmp/ssh /etc/ssh/sshd_config > /dev/null
	echo "Port 2466" >> /etc/ssh/sshd_config > /dev/null
	grep -v "^PasswordAuthentication yes" /etc/ssh/sshd_config > /tmp/passlogin && mv /tmp/passlogin /etc/ssh/sshd_config > /dev/null
	echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config 1> /dev/null 2> /dev/stdout
        sleep 2
       tput setaf 7 ; tput setab 4 ; tput bold ; echo "Preparando configuração dos comandos de gerenciamento de usuários. Por favor aguarde..." ; tput sgr0
        sleep 2
        tput setaf 3 ; tput bold ; echo "Adicionando comando addhost"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/addhost.sh -O /bin/addhost 1> /dev/null 2> /dev/stdout
	chmod +x /bin/addhost
        sleep 1
        tput setaf 5 ; tput bold ; echo "Adicionando comando alterarsenha"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/alterarsenha.sh -O /bin/alterarsenha 1> /dev/null 2> /dev/stdout
	chmod +x /bin/alterarsenha
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando criarusuario"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/criarusuario2.sh -O /bin/criarusuario 1> /dev/null 2> /dev/stdout
	chmod +x /bin/criarusuario
        sleep 1
        tput setaf 1 ; tput bold ; echo "Adicionando comando delhost"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/delhost.sh -O /bin/delhost 1> /dev/null 2> /dev/stdout
	chmod +x /bin/delhost
        sleep 1
        tput setaf 1 ; tput bold ; echo "Adicionando comando expcleaner"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/expcleaner2.sh -O /bin/expcleaner 1> /dev/null 2> /dev/stdout
	chmod +x /bin/expcleaner
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando mudardata"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/mudardata.sh -O /bin/mudardata 1> /dev/null 2> /dev/stdout
	chmod +x /bin/mudardata
        sleep 1
        tput setaf 1 ; tput bold ; echo "Adicionando comando expcleaner"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/remover.sh -O /bin/remover 1> /dev/null 2> /dev/stdout
	chmod +x /bin/remover
        sleep 1
        tput setaf 1 ; tput bold ; echo "Adicionando comando sshlimiter"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/sshlimiter2.sh -O /bin/sshlimiter 1> /dev/null 2> /dev/stdout
	chmod +x /bin/sshlimiter
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando alterarlimite"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/alterarlimite.sh -O /bin/alterarlimite 1> /dev/null 2> /dev/stdout
	chmod +x /bin/alterarlimite
        sleep 1
        tput setaf 2 ; tput bold ; echo "Adicionando comando ajuda"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/ajuda.sh -O /bin/ajuda 1> /dev/null 2> /dev/stdout
	chmod +x /bin/ajuda
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando sshmonitor"; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/sshmonitor.sh -O /bin/sshmonitor 1> /dev/null 2> /dev/stdout
	chmod +x /bin/sshmonitor
        sleep 1
        tput setaf 2 ; tput bold ; echo "Adicionando comando badvpnsetup , para liberar chamada de WhatsApp,jogos e ETC.."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/badvpnsetup.sh -O /bin/badvpnsetup 1> /dev/null 2> /dev/stdout
	chmod +x /bin/badvpnsetup
        sleep 1
        tput setaf 4 ; tput bold ; echo "Adicionando comando tcptweaker, execulte para diminuir o ping do servidor.."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/tcptweaker.sh -O /bin/tcptweaker 1> /dev/null 2> /dev/stdout
	chmod +x /bin/tcptweaker
        sleep 2
        tput setaf 4 ; tput bold ; echo "Adicionando comando userbackup, para salvar todos os usuários criados..."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/userbackup.sh -O /bin/userbackup 1> /dev/null 2> /dev/stdout
	chmod +x /bin/userbackup
        sleep 2
        tput setaf 2 ; tput bold ; echo "Adicionando comando ovpn@servidoressa, para instalar o OpenVPN..."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/openvpnkt.sh -O /bin/ovpn@servidoressa 1> /dev/null 2> /dev/stdout
	chmod +x /bin/ovpn@servidoressa
        sleep 4
        tput setaf 2 ; tput bold ; echo "Adicionando comando otimizar, para fazer otimização do sistema..."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/otimizar.sh -O /bin/otimizar 1> /dev/null 2> /dev/stdout
	chmod +x /bin/otimizar
        sleep 3
        tput setaf 7 ; tput bold ; echo "Adicionando comando speedtest, para medir a velocidade do servidor."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/speedtest.sh -O /bin/speedtest 1> /dev/null 2> /dev/stdout
	chmod +x /bin/speedtest
        sleep 1
        tput setaf 3 ; tput bold ; echo "Adicionando comando detalhes, para ver as configurações do servidor..."; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/detalhes.sh -O /bin/detalhes 1> /dev/null 2> /dev/stdout
	chmod +x /bin/detalhes
        sleep 1
        tput setaf 5 ; tput bold ; echo "Instalando comando limitar, para derrubar usuários que ultrapassam o limite a cada 5 minutos..." ; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/limitar.txt -O /bin/limitar 1> /dev/null 2> /dev/stdout
	chmod +x /bin/limitar
        sleep 2
        tput setaf 2 ; tput bold ; echo "Instalando comando logins, para ver quantos estão conectados..." ; tput sgr0
	wget https://github.com/vinijow/apollosshproject3.0/blob/master/logins.sh -O /bin/logins 1> /dev/null 2> /dev/stdout
	chmod +x /bin/logins
        sleep 2
        tput setaf 3 ; tput bold ; echo "Instalando comando sshmonitor2 para monitorar usuários (com data)..." ; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/sshmonitor.sh -O /bin/sshmonitor2 1> /dev/null 2> /dev/stdout
        chmod +x /bin/sshmonitor2
        sleep 2
        tput setaf 6 ; tput bold ; echo "Instalando comando verdata para verificar a data de 1 unico usuário..." ; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/verdata.sh -O /bin/verdata 1> /dev/null 2> /dev/stdout
        chmod +x /bin/verdata
        sleep 2
        tput setaf 5 ; tput bold ; echo "Instalando comando criarteste , para criar usuários de teste de curto prazo..." ; tput sgr0
        wget https://github.com/vinijow/apollosshproject3.0/blob/master/criarteste.sh -O /bin/criarteste 1> /dev/null 2> /dev/stdout
        chmod +x /bin/criarteste
        sleep 2
       
	if [ ! -f "/etc/init.d/squid" ]
	then
 tput setaf 3 ; tput bold ; echo "Reiniciando o squid..." ; tput sgr0
		service squid restart > /dev/null
	else
		/etc/init.d/squid restart > /dev/null
	fi

	if [ ! -f "/etc/init.d/ssh" ]
	then
 tput setaf 4 ; tput bold ; echo "Reiniciando o SSH..." ; tput sgr0
		service ssh restart > /dev/null
	else
		/etc/init.d/ssh restart > /dev/null
	fi
fi
sed -i '3i\127.0.0.1 portalrecarga.vivo.com.br/recarga/home\' /etc/hosts
sed -i '3i\127.0.0.1 d1n212ccp6ldpw.cloudfront.net\' /etc/hosts
sed -i '3i\127.0.0.1 www.portalsva2.vivo.com.br/captive-static/tarif-def/pd/index.html\' /etc/hosts
echo ""
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Proxy Squid Instalado e rodando nas portas: 80, 3128, 8080 e 8799" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "OpenSSH rodando nas portas 22 e 2466" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Scripts para gerenciamento de usuário instalados" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Para instalar o OpenVPN digite ovpn@servidoressa" ; tput sgr0
tput setaf 7 ; tput setab 4 ; tput bold ; echo "Para ver os comandos disponíveis use o comando: ajuda" ; tput sgr0
echo ""
if [[ "$optiondb" = '2' ]]; then
	awk -F : '$3 >= 500 { print $1 " 1" }' /etc/passwd | grep -v '^nobody' > /root/usuarios.db
fi
if [[ "$sshcompression" = 's' ]]; then
tput setaf 7 ; tput setab 2 ; tput bold ; echo "Compressão SSH ativada." ; tput sgr0;
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
	echo "Compression yes" >> /etc/ssh/sshd_config
fi
if [[ "$sshcompression" = 'n' ]]; then
tput setaf 7 ; tput setab 1 ; tput bold ; echo "Compressão SSH desativada." ; tput sgr0;
	grep -v "^Compression yes" /etc/ssh/sshd_config > /tmp/sshcp && mv /tmp/sshcp /etc/ssh/sshd_config
fi
exit 1
