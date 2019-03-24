#!/bin/bash

# logging function for debugging purposes
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>script_tk.log 2>&1

#elevate to root
sudo -i
whoami

# Get an apt update, add the wireguard ppa & install wireguard
apt update -y && add-apt-repository -y ppa:wireguard/wireguard && apt -y install wireguard

# Change directory to /etc/wireguard
cd /etc/wireguard
pwd

# Generate public and private keys
wg genkey | tee privatekey | wg pubkey > publickey

# variables
# PUBLICIP=$(curl -4 icanhazip.com)
PRIVATE_KEY=$(cat privatekey)
PUBLIC_KEY=$(cat publickey)

# Enable server to forward IP traffic
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1

# Create wg0.conf file
cat << EOF > wg0.conf
[Interface]
Address = ${server_ip}
PrivateKey = $PRIVATE_KEY
ListenPort = 51820
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE

[Peer]
PublicKey = ${client_pubkey}
AllowedIPs = ${allowed_ip}
EOF

# Start wireguard to listen for a connection
wg-quick up wg0