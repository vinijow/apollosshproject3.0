#!/bin/bash
tput setaf 7 ; tput setab 4 ; tput bold ; printf '%30s%s%-15s\n' "Otimizar Servidor 1.0" ; tput sgr0
echo ""
#
tput setaf 2 ; tput bold ; echo "	Atualizando pacotes..." ; tput sgr0
#
apt-get update -y 1>/dev/null 2>/dev/null # Atualizar a lista de pacotes 
#
tput setaf 2 ; tput bold ; echo "	Corrigindo problemas de dependências..." ; tput sgr0
#
apt-get -f install 1>/dev/null 2>/dev/null # Corrigir problemas de dependências, concluir instalação de pacotes pendentes e outros erros
#
tput setaf 2 ; tput bold ; echo "	Removendo pacotes inúteis..." ; tput sgr0
#
apt-get autoremove -y 1>/dev/null 2>/dev/null # Remover pacotes instalados automaticamente e que não tem mais nenhuma utilidade para o sistema
apt-get autoclean -y 1>/dev/null 2>/dev/null # Remover pacotes antigos ou duplicados
#
tput setaf 2 ; tput bold ; echo "	Removendo arquivos inúteis do cache..." ; tput sgr0
#
apt-get clean -y 1>/dev/null 2>/dev/null # Remove arquivos inúteis do cache, onde registra as cópias das atualizações q são instaladas pelo gerenciador de pacotes
#
tput setaf 2 ; tput bold ; echo "	Removendo pacotes com problemas..." ; tput sgr0
#
apt-get -f remove -y 1>/dev/null 2>/dev/null # Remover pacotes com problemas
#
#Limpar o cache da memoria RAM
tput setaf 7 ; tput setab 1 ; printf '  %-30s%s\n' "------------------------------------------------------------------" ; echo "" ; tput sgr0
echo ""
MEM1=`free|awk '/Mem:/ {print int(100*$3/$2)}'`
free -m 
echo ""
echo "Memória RAM Usada antes de fazer a limpeza:" $MEM1% 
echo ""
tput setaf 7 ; tput setab 1 ; printf '  %-30s%s\n' "------------------------------------------------------------------" ; echo "" ; tput sgr0
echo " "
echo "LIMPANDO MEMORIA RAM..."
sleep 3
sync 
echo 3 > /proc/sys/vm/drop_caches
echo "LIMPANDO MEMORIA SWAP..."
echo ""
sleep 4
sync && sysctl -w vm.drop_caches=3 1>/dev/null 2>/dev/null
sysctl -w vm.drop_caches=0 1>/dev/null 2>/dev/null
swapoff -a
swapon -a
tput setaf 7 ; tput setab 1 ; printf '  %-30s%s\n' "------------------------------------------------------------------" ; echo "" ; tput sgr0
echo ""
MEM2=`free|awk '/Mem:/ {print int(100*$3/$2)}'`
free -m 
echo ""
echo "Uso de memória RAM após a limpeza:" $MEM2% "Economia de: " `expr $MEM1 - $MEM2`"%"
tput setaf 2 ; tput bold ; echo "	Reiniciando SSH e Squid..." ; tput sgr0
#
service ssh restart 1>/dev/null 2>/dev/null # Reiniciar SSH
service squid3 restart 1>/dev/null 2>/dev/null # Reiniciar Squid3
service squid restart 1>/dev/null 2>/dev/null # Reiniciar Squid

tput setaf 7 ; tput setab 1 ; printf '  %-30s%s\n' "------------------------------------------------------------------" ; echo "" ; tput sgr0
