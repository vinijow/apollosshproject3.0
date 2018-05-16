#!/bin/bash 
#Autor: The_Apoll0
#@Apoll0
sleep 2
clear
echo ""
echo "--------------------------------------------------------------------"
#
tput setaf 2 ; tput bold ; echo "	Testando no servidor Padrão..." ; tput sgr0
#
speedtest-cli --share
echo ""

echo "--------------------------------------------------------------------"
echo ""
echo "--------------------------------------------------------------------"
speedtest-cli --share --server 4899
#
tput setaf 2 ; tput bold ; echo "	Testando no servidor de São Paulo..." ; tput sgr0
#

echo "--------------------------------------------------------------------"