#!/bin/bash -e

if [ ! /proc/cpuinfo ]
then
tput setaf 1 ; tput bold ; echo "Erro ao obter informações do sistema."
exit 0
fi
if [ ! /etc/issue.net ]
then
tput setaf 1 ; tput bold ; echo "Erro ao obter informações do sistema"
exit 0
fi
if [ ! /proc/meminfo ]
then
tput setaf 1 ; tput bold ; echo "Erro ao obter informações do sistema"
exit 0
fi

system=$(cat /etc/issue.net)
based=$(cat /etc/*release | grep ID_LIKE | awk -F "=" '{print $2}')
processor=$(cat /proc/cpuinfo | grep "model name" | uniq | awk -F ":" '{print $2}')
cpus=$(cat /proc/cpuinfo | grep processor | wc -l)

if [ "$system" ]
then

tput setaf 2 ; tput bold ; echo "Sistema: $system"
else
tput setaf 1 ; tput bold ; echo "Sistema: Não disponível"
fi
if [ "$based" ]
then
tput setaf 2 ; tput bold ; echo "Este é um $based-like"
else
tput setaf 1 ; tput bold ; echo "Based sistema não disponível."
fi
if [ "$processor" ]
then
tput setaf 3 ; tput bold ; echo "Processador: $processor x$cpus"
else
tput setaf 1 ; tput bold ; echo "Processador: Não Disponível."
fi
clock=$(lscpu | grep "CPU MHz" | awk '{print $3}')
if [ "$clock" ]
then
tput setaf 5 ; tput bold ; echo "Clock: $clock MHz"
else
tput setaf 1 ; tput bold ; echo "Clock: Não Disponível."
fi
tput setaf 1 ; tput bold ; echo "$(ps aux  | awk 'BEGIN { sum = 0 }  { sum += sprintf("%f",$3) }; END { printf "Uso de CPU: " "%.2f" "%%", sum}')"
totalram=$(free | grep Mem | awk '{print $2}')
usedram=$(free | grep Mem | awk '{print $3}')
freeram=$(free | grep Mem | awk '{print $4}')
swapram=$( cat /proc/meminfo | grep SwapTotal | awk '{print $2}')
tput setaf 4 ; tput bold ; echo "MEMORIA RAM: $(($totalram / 1024))MB Usado $(($usedram / 1024))MB Livre: $(($freeram / 1024))MB SWAP: $(($swapram / 1024))MB "
tput setaf 2 ; tput bold ; echo "Uptime: $(uptime)"
tput setaf 8 ; tput bold ; echo "Hostname: $(hostname)"
tput setaf 3 ; tput bold ; echo "IP: $(ip addr | grep inet | grep -v inet6 | grep -v "host lo" | awk '{print $2}' | awk -F "/" '{print $1}')"
tput setaf 7 ; tput bold ; echo "Kernel Version: $(uname -r)"
tput setaf 6 ; tput bold ; echo "Arquitetura: $(uname -m)"