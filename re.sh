#!/bin/bash
CONFIG="$1"
COMMAND="$2"

# Check if first paramter has virtual host
FILEMATCH=false

# Create string of the virtual hosts
VALID_VHOSTS=''

# Make list of every virtual host file
VHOSTS=/etc/apache2/sites-available/*.conf

if [ $# -ne 2 ]
then
    echo "ERROR: $0 requires two parameters {virtual-host} {restart|reload}"
    exit 1
fi

# Loop through the all files in the sites-avaliable directory
# Build a list of filenames to display in the error message
# If we find a match set $FILEMATCH to true and stop build the list
for FILENAME in $VHOSTS
do

  VHOST="${FILENAME:29:-5}"
  # Add each virtual-host in the sites-available directory to 
  # the VHOSTS string. This will provide user feedback if there
  # is an error
  if [ -z  "$VALID_VHOSTS" ]
    then
      VALID_VHOSTS="\n * $VHOST"
    else
      VALID_VHOSTS="${VALID_VHOSTS}\n * $VHOST"
    fi

  if [ "$FILENAME" == "/etc/apache2/sites-available/${CONFIG}.conf" ]
  then
    # Set $FILEMATCH to true if one of those files matches an actual
    # virtual-host configuration and break the loop
    FILEMATCH=true
    break
  fi
done

# We could not match the firstargument to a virtual-host preset the user with an error
if [ $FILEMATCH  == false ]
then
    echo -e "\e[31mERROR:\e[0m \e[1m\e[33m${CONFIG}\e[0m \e[31mis NOT a valid virtual-host\e[0m \nPlease choose from the following ${VALID_VHOSTS}"
    exit 1
fi

# only allow reload or restart.
if [ "$COMMAND" == "reload" ] || [ "$COMMAND" == "restart" ]
then
    # Move the current execution state to the proper directory
    cd /etc/apache2/sites-available

    # Disable a vhost configuration
    sudo a2dissite "$CONFIG"
    sudo service apache2 "$COMMAND"

    # Enable a vhost configuration
    sudo a2ensite "$CONFIG"
    sudo service apache2 "$COMMAND"

else
    echo -e "\e[31mERROR:\e[0m \e[1m\e[33m${COMMAND}\e[0m \e[31mis NOT a valid service command\e[0m \nPlease choose from the following \n * restart \n * reload"
    exit 1
    # echo "ERROR: $COMMAND is an invalid service command {restart|reload}"
    # exit 1
fi

#test the lab-test branch