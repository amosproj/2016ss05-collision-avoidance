#
# amos-ss16-proj5-gui.sh
# Projectname: amos-ss16-proj5
#
# Created on 28.05.2016.
# Copyright (c) 2016 de.fau.cs.osr.amos2016.gruppe5
#
# This file is part of the AMOS Project 2016 @ FAU
# (Friedrich-Alexander University Erlangen-Nürnberg)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public
# License along with this program. If not, see
# <http://www.gnu.org/licenses/>.
#

#amos-ss16-proj5.sh [ _CONTAINER_TAG_ ] [ _FULL_PATH_TO_FILE_ ] [ _NAME_OF_NETWORK_ ] [ _PORT_ ]
#!/bin/bash
# Script for easier docker usage
set -e
echo -en '\n'
echo "AMOS Group 5 Start Script"
echo "This script will start our docker container for you. Please give a port number, the tag for the docker image you want to start, the name of a docker network, and pick either an mp4 or hdf5 file."

# Open Form for start parameters
OUTPUT=$(zenity --forms --title="Amos SS16 Proj5" --text="Enter program parameters" --separator="," --add-entry="Docker Network Name" --add-entry="Port")
accepted=$?
if ((accepted != 0)); then
    echo "something went wrong"
    exit 1
fi

# read parameters from form
network=$(awk -F, '{print $1}' <<<$OUTPUT)
port=$(awk -F, '{print $2}' <<<$OUTPUT)

# check for blank fields
if [ "$network" == "" ] || [ "$port" == "" ];then
	zenity --error --text="No empty parameters allowed"
	echo -en '\n'
	echo "Thanks for using our program!"
	exit 1
fi

# open file manager to pick mp4 or hdf5 files
FILE=`zenity --file-selection --multiple --title="Select either an mp4 or hdf5 File" --separator=";" --file-filter='*.mp4 *.hdf5 *.MP4 *.HDF5'`
IFS=';'; arrFiles=($FILE); unset IFS;
# Get script directory 
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for i in "${arrFiles[@]}"; do
	# Showing current file used for detection for viewers
	echo "Loading new file: $i"
	# Checking if the given files are valid
	if [ ! -f "$i" ]; then
		zenity --error --text="Filepath invalid: $i"
		echo -en '\n'
		echo "Thanks for using our program!"
		exit 1
	fi	

	# Start the server -- needs the docker network, container tag, and the server port
	gnome-terminal -e "$dir/helper.sh $network release $port"
	# Little sleep before starting, so you can actually read about the file and server can startup
	sleep 3


	# HDF5 File given
	if [ "${i##*.}" == "hdf5" ]; then
		# checking if client is running / exited
		containerRunning=$(docker ps -a -f name=clientContainer)
		flag=`echo $containerRunning|awk '{print match($0,"clientContainer")}'`;
		#echo $flag
		if [ $flag -gt 0 ]; then
		  docker stop clientContainer
		  docker rm -fv clientContainer
		fi
	
		# Getting server ip via docker network
		echo "Fetching server ip"
		echo -en '\n'
		line=$(docker network inspect $network | sed -n '/serverContainer/{n;n;n;p}')
		ip=$(echo $line | cut -c17-26)
	
		# Configuring the xhost
		echo "Configuring xhost"
		xhost +local:
	
		# Starting the client inside the docker container
		echo "Starting the client"
		echo -en '\n'
		docker run -ti --name=clientContainer --net=$network -v $i:/home/hdf5file.hdf5 -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -e LD_LIBRARY_PATH=/home/openCV/lib:$LD_LIBRARY_PATH amosproj5/amosbuildimage:release /bin/bash -c "ln -s /dev/null /dev/raw1394; cd /home/bin/; ./amos-ss16-proj5 $port $ip ../hdf5file.hdf5"
		echo -en '\n'
		xhost -local:
		echo "Reverting xhost settings..."
		echo -en '\n'
		echo "Thanks for using our program!"
#		exit 0
	fi

	# mp4 File given
	if [ "${i##*.}" == "mp4" ]; then
	  	# checking if client is running / exited
		containerRunning=$(docker ps -a -f name=clientContainer)
		flag=`echo $containerRunning|awk '{print match($0,"clientContainer")}'`;
		echo $flag
		if [ $flag -gt 0 ]; then
		  docker stop clientContainer
		  docker rm -fv clientContainer
		fi
	
		# Getting server ip via docker network
		echo "Fetching server ip"
		echo -en '\n'
		line=$(docker network inspect $network | sed -n '/serverContainer/{n;n;n;p}')
		ip=$(echo $line | cut -c17-26)
	
		# Configuring the xhost
		echo "Configuring xhost"
		xhost +local:
	
		# Starting the client inside the docker container
		echo "Starting the client"
		echo -en '\n'
		docker run -ti --name=clientContainer --net=$network -v $i:/home/mp4file.mp4 -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -e LD_LIBRARY_PATH=/home/openCV/lib:$LD_LIBRARY_PATH amosproj5/amosbuildimage:release /bin/bash -c "ln -s /dev/null /dev/raw1394; cd /home/bin/; ./amos-ss16-proj5 $port $ip ../mp4file.mp4"
		echo -en '\n'
		xhost -local:
		echo "Reverting xhost settings..."
		echo -en '\n'
		echo "Thanks for using our program!"
#		exit 0
	fi
	
done



