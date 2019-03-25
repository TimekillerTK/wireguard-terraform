#!/bin/bash

# Logging function
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>./script_tk.log 2>&1

pwd

# Get client private key and store it in a variable
PRIVKEY=$(cat ~/privatekey)

# modify the wg0.conf file
sed -i -e "s/EMPTY/$PRIVKEY/g" ./files/wg0.conf