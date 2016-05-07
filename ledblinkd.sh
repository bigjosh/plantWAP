#!/bin/bash

# This script continually blinks LEDs connected to GPIOs 17 & 18 on a Raspberry Pi

# Enable output on pins
# note the sleep 1 gives the OS time to complete the action


#set -e
set -x

sudo echo "17" > /sys/class/gpio/export
sleep 1
sudo echo "out" > /sys/class/gpio/gpio17/direction
sleep 1

sudo echo "18" > /sys/class/gpio/export
sleep 1
sudo echo "out" > /sys/class/gpio/gpio18/direction
sleep 1


# loop blinking forever

while true; do

	sudo echo "1" > /sys/class/gpio/gpio17/value
	sleep 1
	sudo echo "1" > /sys/class/gpio/gpio18/value
	sleep 2
	sudo echo "0" > /sys/class/gpio/gpio17/value
	sudo echo "0" > /sys/class/gpio/gpio18/value
	sleep 2
	sudo echo "1" > /sys/class/gpio/gpio17/value
	sleep 1
	sudo echo "1" > /sys/class/gpio/gpio18/value
	sleep 1
	sudo echo "0" > /sys/class/gpio/gpio17/value
	sudo echo "0" > /sys/class/gpio/gpio18/value
	sleep 1
done
