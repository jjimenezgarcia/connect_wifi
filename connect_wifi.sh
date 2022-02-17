#!/bin/bash

#Colours
declare -r greenColour="\e[0;32m\033[1m"
declare -r endColour="\033[0m\e[0m"
declare -r redColour="\e[0;31m\033[1m"
declare -r blueColour="\e[0;34m\033[1m"
declare -r yellowColour="\e[0;33m\033[1m"
declare -r purpleColour="\e[0;35m\033[1m"
declare -r turquoiseColour="\e[0;36m\033[1m"
declare -r grayColour="\e[0;37m\033[1m"


trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${redColour}[!] Exitting...${endColour}\n"
	exit 1
}

function list_wifis(){
	echo -e "${yellowColour}\n[-] Listing connections...\n ${endColour}"
	nmcli d wifi list
}

function connection_function(){
	ssid=$1
	password=$2
	
	if [ $ssid ]; then
		if [ $password ];then
			echo -e "\n${yellowColour}Connecting to SSID $ssid using password $password ...${endColour}"	
			if echo $password | nmcli --ask dev wifi connect $ssid >/dev/null; then
				echo -e "${greenColour}[-]Connected${endColour}"				
			else
				echo -e "${redColour}\n[!] Not possible to connect, exitting now${endColour}"
				exit 1
			fi
		else 
			echo -e "${redColour}\n[!] Password error, usage:${endColour} -c \"SSID\" password"
		fi
	else
		echo -e "${redColour}\n[!] SSID error, usage:${endColour} -c \"SSID\" password"
	fi

}

function help_function(){
	for i in $(seq 1 80); do echo -ne "${redColour}-"; done; echo -ne "${endColour}"
	echo -e "\n${yellowColour}Usage:${endColour}"
	echo -e "\t\t${greenColour}[-h]${endColour}:\t${grayColour}show this help menu${endColour}"
	echo -e "\t\t${greenColour}[-l]${endColour}:\t${grayColour}list current WiFis${endColour}"
	echo -e "\t\t${greenColour}[-c]${endColour}:\t${grayColour}connect to WiFi\t\t(Example: -c \"SSID\" password)${endColour}"
}

parameter_counter=0
tput civis; while getopts "lch" arg; do
	case $arg in
		l) list_mode=1 && let parameter_counter+=1;;
		c) connection_mode=1 && let parameter_counter+=1;;
		h) help_function;;
	esac
done

if [ "$parameter_counter" != "0" ]; then
	if [ $list_mode ]; then
          list_wifis
	elif [ $connection_mode ]; then
	  connection_function $2 $3
  	fi

else
	help_function
fi
