#!/bin/bash
# Snaps an image from a connected webcam and rotates it into the web directory
# Note that there must be a placehold image in /etc/pantWAP/images for each
# Live image you want to appear in pages. Live images have names like
# live-05.jpg. The "05" can be anything. The number of placehold images
# controls how many live images will be kept 

echo Starting live webcam capture service

#number of minutes between images
mwait=1

#where to store the images
idir="/var/www/html/images"

# note that livemask should never be in quotes or it will not expand (argh!)
livemask="$idir/live-*"

echo "Updating every $mwait minutes to $livemask"

step=0 

while true; do

    # first check to see if the destination directory has any live- files in it

    if [ ! -e $livemask -type f ]; then
        # special case no live files since find will crash if no matches
        scount=0
    else 
        #get the soruce files 
        sfiles=( $(find $livemask -type f) )
        #how many source images do we have?
        scount=${#sfiles[@]}    
    fi

    if (( scount > 0 )); then

        f=$(tempfile)

        # output a jpg file with relativelyt low quailty so it is small
        fswebcam --jpeg 40 "$f"

        sudo cp "$f" "${sfiles[step]}"

        rm "$f"
        
        step=$((step + 1))
        
        if (( step == scount )); then
            step=0;
        fi
    fi 
    
    sleep $(( mwait * 60 ))
    
done