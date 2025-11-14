# Nginx-Load-Balancer-Setup-on-EC2

## Overview

This project provisions an AWS infrastructure using Terraform to deploy a simple NGINX load balancer. The setup includes:

* One public EC2 instance acting as the NGINX load balancer
* Two private EC2 instances acting as backend web servers
* Automated NGINX installation using user-data scripts
* A modular Terraform structure separating networking, security, and compute resources

After provisioning, NGINX is manually configured on the public instance to load balance traffic across both backend servers using the round-robin method.

---

## Architecture Diagram

![Architecture Diagram](Documentation%20&%20Arch%20Diagram/nginx-loadbalancer.drawio.png)


The public EC2 instance receives external traffic and forwards it to backend EC2 instances located in a private subnet. Backend instances are not directly accessible from the internet.

---

## Prerequisites

### Local Requirements

* Terraform v1.0 or later
* AWS CLI configured using `aws configure`
* IAM user with permissions for EC2, VPC, NAT, Subnets, and S3
* Existing AWS key pair in the target region
* Ability to SSH into EC2 instances

### AWS Requirements

* An S3 bucket created manually for Terraform remote state
* The bucket name and key referenced in `backend.tf`
* No DynamoDB table is required

### Network Assumptions

* **VPC:** 10.0.0.0/16
* **Public subnet:** 10.0.1.0/24
* **Private subnet:** 10.0.2.0/24
* **Public EC2 (Load Balancer):** Public access via IGW
* **Private EC2s (Backend):** Access restricted to the load balancer
* **NAT Gateway:** Required for backend user-data script package installation

---

## Project Structure

```
├── backend.tf
├── main.tf
├── modules
│   ├── network
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ec2
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── userdata-lb.sh
│       └── userdata-backend.sh
├── outputs.tf
├── provider.tf
├── terraform.tfvars
└── variables.tf
```

This modular layout isolates networking, security, and EC2 compute logic, making maintenance and future scalability easier.

---

## Terraform Deployment Instructions

### 1. Initialize Terraform

```
terraform init
```

### 2. Validate configuration

```
terraform validate
```

### 3. Review infrastructure changes

```
terraform plan
```

### 4. Deploy infrastructure

```
terraform apply
```

This creates the VPC, IGW, NAT Gateway, subnets, security groups, and three EC2 instances.
User-data scripts automatically install NGINX on each instance.

---

## NGINX Configuration

### Backend EC2 Instances (Private Subnet)

On each backend EC2:

* Keep the default NGINX configuration
* Edit `/usr/share/nginx/html/index.html` and add a unique message such as:

  * “Welcome from Backend Server 1”
  * “Welcome from Backend Server 2”

These messages help verify load balancing behavior.

### Load Balancer EC2 Instance (Public Subnet)

On the public EC2:

* Modify `/etc/nginx/nginx.conf` to include an upstream group
* Add a server block that proxies traffic to backend instances
* Restart NGINX:

```
sudo systemctl restart nginx
```

---

## Testing the Load Balancer

1. Get the public IP of the load balancer EC2 instance
2. Open the public IP in a browser
3. Refresh the page repeatedly
4. The responses should alternate between the backend servers:

Example:

* Welcome from Backend Server 1
* Welcome from Backend Server 2
* Welcome from Backend Server 1
* Welcome from Backend Server 2

This confirms round-robin load balancing is working.

---

## Troubleshooting

### User-data script not running

Common causes and fixes:

#### 1. NGINX installation failed during cloud-init

Check logs:

```
cat /var/log/cloud-init-output.log
```

#### 2. `yum` was locked by system updates

Amazon Linux often runs automatic package updates on first boot.

Fix:

```
sudo systemctl disable packagekit
sudo systemctl stop packagekit
```

Then re-run commands manually if needed.

#### 3. Manual installation fallback

SSH into each instance and run:

```
amazon-linux-extras install -y nginx1
systemctl start nginx
systemctl enable nginx
```

Verify:

```
systemctl status nginx
```

### Backend instances unreachable

* Ensure backend SG allows HTTP only from the load balancer SG
* Confirm NAT Gateway exists for package installation on private instances

---

## Cleanup

To delete all resources:

```
terraform destroy
```

---


