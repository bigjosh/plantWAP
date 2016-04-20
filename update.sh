#!/bin/bash

echo "Stopping any running services (this could take a minute)..."

#set all our services to run on boot up
sudo service isc-dhcp-server stop
sudo service hostapd stop
sudo service apache2 stop
sudo service squid3 stop


#update and changes, typically run after a "git pull"

#copy out files where they all go
sudo cp -r root/etc/* /etc/
 
#make the squid rewrite helper executable
sudo chmod +x /etc/plantwap/sqwrite.sh

#source for images to inject
sdir="/etc/plantwap/images"

#location to cache resized images
idir="/var/www/html/images"

if [ ! -d "$idir" ]; then
	# make directory for generated images, fails benignly if race condition
	sudo mkdir "$idir" 
fi

#give the rewriter permision to images in the local web server dir
sudo mkdir /var/www/html/images/
sudo chown -c proxy /var/www/html/images/

# clear anything left in directory
rm -f $idir/*

#copy files & set permisisons
sudo cp "$sdir"/* "$idir"/*
chmod a+r "$idir"/*

#set all our services to run on boot up
sudo service isc-dhcp-server start
sudo service hostapd start
sudo service apache2 start
sudo service squid3 start

echo All done! We should now be serving plants!