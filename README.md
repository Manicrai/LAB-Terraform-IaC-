# Azure Hub & Spoke Architecture with Terraform

This repository contains the Terraform Infrastructure as Code (IaC) configuration to deploy a standard **Hub and Spoke** network topology in Microsoft Azure.

## 🏗️ Architecture Overview

The deployed architecture maps out a centralized management hub network with multiple isolated environment networks designed for strict security boundaries.
- **Hub Virtual Network (VNet):** Acts as the central point of connectivity. Contains a dedicated shared services subnet with a small Bastion "Jumpbox" Virtual Machine (Ubuntu) exposed via SSH for administrative access. Also contains a Gateway Subnet reserved for future VPN/ExpressRoute configurations.
- **Spoke VNets (Prod & Dev):** Two completely separate VNets representing Production and Development environments. Both are peered directly to the Hub VNet.
- **Network Security Groups (NSGs):** NSG rules are strategically placed on the Spoke subnets to enforce complete isolation. Traffic from Development is denied entry into Production, and vice versa.
- **Internal VMs:** One Ubuntu VM is deployed into both Spoke subnets with internal IP addresses exclusively, permitting connectivity checks from the centralized Hub Jumpbox point.

## 🚀 Deployment Instructions (Azure Cloud Shell)

Due to corporate proxy restrictions and network configurations, deploying via Azure Cloud Shell is highly recommended. 

1. Create a `hub-spoke` directory in your Azure Cloud Shell environment and upload the provided files or `.zip` archive.
2. Initialize Terraform to download the required Azure provider plugins:
   ```bash
   terraform init
   ```
3. Execute the deployment plan and create the resources automatically:
   ```bash
   terraform apply -auto-approve
   ```
4. Upon successful deployment, Terraform will output the public IP of the `jumpbox` and the private IPs of the Prod and Dev VMs.
5. Connect to the Jumpbox via SSH using the provided credentials (`adminuser` / `P@ssw0rd1234!`) and perform internal SSH/Ping tests to your private Spoke infrastructure to validate successful connection isolation!

**Note:** Don't forget to run `terraform destroy -auto-approve` when finished to prevent unwanted Azure consumption charges.