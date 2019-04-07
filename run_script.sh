#!/bin/bash

# Rewrite - add terraform apply here and run post_deploy.sh here after terraform plan is completed
# Terraform output is only generated once the apply is finished, so this is the only way I can see this working 

#Terraform plan & apply, will be waiting for prompt for yes here
terraform apply -input=false

#Run post deployment script
echo "Waiting 90 seconds for wireguard.sh to complete ..."
sleep 90 && sh ./files/post_deploy.sh