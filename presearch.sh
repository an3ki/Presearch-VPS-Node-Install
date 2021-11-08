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
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
    sudo apt-get update > /dev/null 2>&1;
      
	check_exit_status
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
    echo -e "- Now Installing Firewall and Fail2Ban! -"
    echo -e "-----------------------------------------${NC}"
    echo -e ""

	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get install ufw > /dev/null 2>&1;
	  
	
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo ufw default allow outgoing > /dev/null 2>&1;
	  
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo ufw allow ssh > /dev/null 2>&1;
	  
	check_exit_status
	sudo ufw allow 8080 > /dev/null 2>&1;
	  
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	echo -e "y" | ufw enable > /dev/null 2>&1;
	  
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get install -y fail2ban > /dev/null 2>&1;
	  
	check_exit_status
	
	cat << EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
EOF
	  
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo systemctl start fail2ban;> /dev/null 2>&1;
	  
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo systemctl enable fail2ban;> /dev/null 2>&1;
	  
	check_exit_status
	}

Presearch () {

    clear
    echo -e "${CYAN}-------------------------------------"
    echo -e "- Now Installing Docker & Presearch Node! -"
    echo -e "-------------------------------------${NC}"
    
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get update > /dev/null 2>&1;
	  
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get install \
    	ca-certificates \
    	curl \
    	gnupg \
    	lsb-release > /dev/null 2>&1;
	  
	check_exit_status
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg > /dev/null 2>&1;
		  
	check_exit_status
   	 echo -e "${GREEN}Loading......Please Wait.........${NC}"
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null > /dev/null 2>&1;
	check_exit_status
	
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get update > 2>&1;
	check_exit_status
	
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo apt-get install docker-ce docker-ce-cli containerd.io > 2>&1;
	check_exit_status
	
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo docker run -d --name presearch-auto-updater --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater presearch-node > 2>&1;
	check_exit_status
	
	echo -e "${GREEN}Loading......Please Wait.........${NC}"
	sudo docker pull presearch/node > 2>&1;
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
