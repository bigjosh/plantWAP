#!/bin/bash

set -x
set -e

echo "Stopping any running services (this could take a minute)..."

#set all our services to run on boot up
sudo service isc-dhcp-server stop
sudo service hostapd stop
sudo service apache2 stop
sudo service squid3 stop
sudo service snapd stop

#update and changes, typically run after a "git pull"

#copy out files where they all go
sudo cp -r root/etc/* /etc/
 
#make the squid rewrite helper executable
sudo chmod +x /etc/plantwap/sqwrite.sh
sudo chmod +x /etc/plantwap/snapd.sh


#source for images to inject
sdir="/etc/plantwap/images"

#location to cache resized images
idir="/var/www/html/images"

if [ ! -d "$idir" ]; then
	# make directory for generated images, fails benignly if race condition
	sudo mkdir "$idir" 
else 
	# directory exists, so clear contents
	rm -f $idir/*	
fi

#give the rewriter permision to images in the local web server dir
sudo chown -c proxy /var/www/html/images/

#copy files & set permisisons
sudo cp "$sdir"/* "$idir"
chmod a+r "$idir"/*

#enable live webcam updater (or reinitialize the service in case we changed the service file)
sudo systemctl enable /etc/plantwap/snapd.service

#set all our services to run on boot up
sudo service isc-dhcp-server start
sudo service hostapd start
sudo service apache2 start
sudo service squid3 start
sudo service snapd start

echo All done! We should now be serving plants!