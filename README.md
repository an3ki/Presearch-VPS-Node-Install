# Presearch
Script to run a Presearch Node
To Install a new Presearch Node on Ubuntu 18.04, 20.04, 21.04, 21.10 x64 

Please enter the following command in the terminal as a root user (Install may take up to 15 minutes)

You will also need your node registration code which can be found here: https://nodes.presearch.org/dashboard

	sudo wget https://raw.githubusercontent.com/an3ki/Presearch/master/presearch.sh

	chmod +x preearch.sh

	source presearch.sh


Once Installed run the command to see the status of your node:
	
	sudo docker logs presearch-node
  
You can now go back to https://nodes.presearch.org/dashboard to stake the required 2000 pre for your node
	
