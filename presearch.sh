#!/bin/bash
NODEIP=$(curl -s4 icanhazip.com)
CYAN="\033[0;34m"
YELLOW="\033[0;33m"
CYAN="\033[0;36m" 
PURPLE="\033[0;35m"
GREEN='\033[0;31m'
GREEN="\033[0;32m"
NC='\033[0m'
MAG='\e[1;35m'
check_exit_status() {

    if [ $? -eq 0 ]
    then
        echo -e
        echo -e "Success"
        echo -e
    else
        echo -e
        echo -e "[ERROR] Process Failed!"
        echo -e
		
        read -p "The last command exited with an error. Exit script? (yes/no) " answer

        if [ "$answer" == "yes" ]
        then
            exit 1
        fi
    fi
}

greeting() {

    clear
    echo -e
    echo -e "${YELLOW}Hello, $USER. This script will install a Presearch Node.${NC}"
    echo -e ""
    read -n 1 -s -r -p "Press any key to continue....."
}

update() {

    clear
    echo -e "${CYAN}------------------------"
    echo -e "- Updating the System! -"
    echo -e "------------------------${NC}"
    echo -e ""
	echo -e "${GREEN}Checking for updates:${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
    sudo apt-get update > /dev/null 2>&1;
      
	check_exit_status
	echo -e "${GREEN}Installing new updates:${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
    sudo apt-get upgrade -y > /dev/null 2>&1;
      
	
	check_exit_status
}

housekeeping() {

	clear
    echo -e "${CYAN}---------------------------------"
    echo -e "- Performing Some Housekeeping! -"
    echo -e "---------------------------------"
    echo -e ""
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
    sudo apt-get autoremove -y > /dev/null 2>&1;
      
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
    sudo apt-get autoclean -y > /dev/null 2>&1;
      
	check_exit_status
	}

Firewall() {

	clear
    echo -e "${CYAN}-----------------------------------------"
    echo -e "- Now Installing Fail2Ban! -"
    echo -e "-----------------------------------------${NC}"
    echo -e ""

	
	echo -e "${GREEN}Getting latest version of Fail2Ban${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get install -y fail2ban > /dev/null 2>&1;
	  
	check_exit_status
	
	echo -e "${GREEN}Setting up default settings${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	
	cat << EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = 22
filter = sshd
maxretry = 5
bantime  = 86400
findtime = 60
EOF
	  
	check_exit_status
	echo -e "${GREEN}Adding Fail2Ban to start on reboot${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo systemctl start fail2ban;> /dev/null 2>&1;
	  
	check_exit_status
	echo -e "${GREEN}Enabling Fail2Ban${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo systemctl enable fail2ban;> /dev/null 2>&1;
	  
	check_exit_status
	}

Presearch () {

    clear
    echo -e "${CYAN}-------------------------------------"
    echo -e "- Now Installing Docker & Presearch Node! -"
    echo -e "-------------------------------------${NC}"
    
	echo -e "${GREEN}Getting latest updates${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get update > /dev/null 2>&1;
	check_exit_status
	echo -e "${GREEN}Removing previous version of Docker${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get remove docker docker-engine docker.io > /dev/null 2>&1;
	check_exit_status
	echo -e "${GREEN}Installing Docker Dependencies${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get install \
    	ca-certificates \
    	curl \
    	gnupg \
    	lsb-release > /dev/null 2>&1;
	  
	check_exit_status
	echo -e "${GREEN}Downloading Latest version of Docker${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	curl -fsSL https://get.docker.com -o get-docker.sh > /dev/null 2>&1;
	check_exit_status
	
	echo -e "${GREEN}Installing Docker${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo sh get-docker.sh  
	check_exit_status
   		
	echo -e "${GREEN}Installing PreSearch Auto Updater${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo docker run -d --name presearch-auto-updater --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater presearch-node
	check_exit_status
	
	echo -e "${GREEN}Downloading Latest PreSearch Node${NC}"
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo docker pull presearch/node
	check_exit_status
}

leave() {

    clear
    echo -e "${MAG}----------------------------------------------------------------------------------------------------------------------------"
    echo -e "- Installlation Partially Complete! -"
    echo -e "- Please visit ${YELLOW}https://nodes.presearch.org/dashboard/ ${MAG}"
	echo -e "- To register your node -"
	echo -e " "
	echo -e " "
	echo -e "-Please enter your node registration code to continue ( example 5eb11dc9b3bd28f9487f18d8e8579d96 )-"
	echo -e " "
	echo -e " You can get your node registration code from the website under Node overview -"
	echo -e "-----------------------------------------------------------------------------------------------------------------------------"
    echo -e "${CYAN}Please enter your Node registration code:-   ${NC}"
    read -p "" VALIDATE
}

gonode() {

	sudo docker run -dt --name presearch-node --restart=unless-stopped -v presearch-node-storage:/app/node -e REGISTRATION_CODE=$VALIDATE presearch/node > /dev/null 2>&1;
	  
	check_exit_status


}
startnode() {
 clear
   	echo -e "${MAG}----------------------------------------------------------------------------------------------------------------------------"
   	echo -e "- Installlation Complete! -"
	echo -e "- "
	echo -e " "
	echo -e ""
	echo -e " "
	echo -e "${MAG}After this your node is complete and you may exit the terminal."
	echo -e ""
	echo -e "${MAG}To view your node working use the command:${YELLOW} sudo docker logs -f presearch-node${NC}"
	echo -e ""
	echo -e "${MAG} You can check the status of your node at anytime using this command:${YELLOW} sudo docker ps${NC}"
	echo -e "${MAG} For any other help please visit:${GREEN} https://docs.presearch.org/${NC}"
	echo -e " "
	echo -e "${MAG}Don't forget to press ${YELLOW}CTRL C ${MAG}beofore you exit terminal${NC}"

}

greeting
update
housekeeping
Firewall
Presearch
leave
gonode
startnode
