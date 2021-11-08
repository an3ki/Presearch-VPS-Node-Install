# Presearch
Automatic Script to run a Presearch Node on Ubuntu 18.04, 20.04, 21.04*, 21.10*  x64

Please enter the following command in the terminal as a root user (Install may take up to 15 minutes)

You will also need your node registration code which can be found here: https://nodes.presearch.org/dashboard

	sudo wget https://raw.githubusercontent.com/an3ki/Presearch/master/presearch.sh

	chmod +x presearch.sh

	source presearch.sh


Once Installed run the command to see the status of your node:
	
	sudo docker logs presearch-node
  
You can now go back to https://nodes.presearch.org/dashboard to stake the required 2000 pre for your node




*For Ubuntu 21.04, 21.10 x64 1 small extra step when you see this image press tab then enter

![20](https://user-images.githubusercontent.com/4707851/140717268-ec91a57c-d9e7-4bf4-b753-41399cb5f428.png)
	
