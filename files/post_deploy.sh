#!/bin/bash

# Get client private key and store it in a variable
PRIVKEY=$(cat ~/privatekey)

# modify the wg0.conf file
sed -i -e "s/EMPTY/$PRIVKEY/g" ./output/wg0.conf