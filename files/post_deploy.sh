#!/bin/bash

ELASTICIP=$(terraform output eip)
OUTPUTFOLDER=$(terraform output out_folder)

# The key below needs to be turned into a variable (!)
scp -i /home/tk/.ssh/Neko-VPN.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@$ELASTICIP:/wg_client/wg0.conf $OUTPUTFOLDER/wg0.conf

# Get client private key and store it in a variable
PRIVKEY=$(cat ./input/privatekey)

# modify the wg0.conf file
sed -i -e 's#EMPTY#'$PRIVKEY'#g' $OUTPUTFOLDER/wg0.conf

# New Method 's#EMPTY#'$PRIVKEY'#g'
# Previous Broken Method: "s/EMPTY/$PRIVKEY/g"