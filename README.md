## Terraform for Wireguard VPN on AWS
Deploys an AWS EC2 instance for Wireguard VPN.

### **Prequisites:**
* AWS Account
* [AWS CLI tool](https://aws.amazon.com/cli/) 
* Add Keypair in AWS & add same key to local `ssh-agent` for post-deploy script
* [Terraform](https://www.terraform.io/downloads.html)
* Install Wireguard on client (for generating keys)
* Linux environment (tested under Ubuntu WSL)

### **How to use:**

1. Configure AWS CLI profile `neko-vpn` with your AWS Access Key ID & Secret. Choose `eu-west-1` as the region and set format to `json`.
2. Create `terraform.tfvars` with the following variables:
```terraform
client_pub_key = "PUBLICKEY"
client_pub_ip = "IPADDRESS/32"
keypair_name = "NAME"
```
   * `client_pub_key` - insert public key generated with Wireguard. This command `wg genkey | tee privatekey | wg pubkey > publickey` will export both public and private keys 
   * `client_pub_ip` - go to https://www.whatsmyip.org or `curl -4 icanhazip.com` to get your client's public IP. Use CDIR notation `xxx.xxx.xxx.xxx/32`
   * `keypair_name` - name of the Keypair added to AWS
3. Run `terraform init`, then `terraform apply` to create & bootstrap the AWS EC2 instance with Wireguard.
4. Copy `./output/wg0.conf` to `/etc/wireguard` on your Wireguard client.
5. Run `wg-quick up` to initiate the Wireguard VPN connection.

***

### **To Do**
* Add support for multiple regions (currently set up to `eu-west-1`)
* ~~Set output folder as variable with default set to `./output`~~ Added in `29c3049`
* Update `README.md` to provide better step-by-step instructions
* Harden linux VM, currently its only firewalled off

#### Far future...
* Add support for different cloud providers (Azure, GCP, Digital Ocean,etc)
* Move to Alpine Linux VM for better performance & efficiency
* 