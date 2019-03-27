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
   * `client_pub_key` - insert public key generated with Wireguard
     * This command `wg genkey | tee privatekey | wg pubkey > publickey` will export both public and private keys 
   * `client_pub_ip` - go to https://www.whatsmyip.org or `curl -4 icanhazip.com` to get your client's public IP. Use CDIR notation `xxx.xxx.xxx.xxx/32`
   * `keypair_name` - name of the Keypair added to AWS

```terraform
client_pub_key = "PUBLICKEY"
client_pub_ip = "IPADDRESS/32"
keypair_name = "NAME"
```