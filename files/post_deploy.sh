#!/bin/bash

# Steps to take after deployment is completed (run on Wireguard client). Might not be needed

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>./script_tk.log 2>&1


pwd >> test_pwd.txt