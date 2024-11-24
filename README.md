### README.md  
# Reusable Terraform Script for 3-Tier Application  

# Overview  
This Terraform module deploys a highly available 3-tier application architecture with the following features:  
- **Web, App, and Database Tiers** with distinct subnets for isolation.  
- **High Availability** using AMI backups and Auto Scaling Groups for Web and App tiers.  
- **Load Balancers** for traffic distribution between instances.  
- **RDS Database** with Multi-AZ for fault tolerance.  

# Components  
1. **Web Tier**:  
   - Instances with a public-facing Load Balancer.  
   - Auto Scaling based on AMI backups.  

2. **App Tier**:  
   - Instances with a private-facing Load Balancer connected to the Web tier.  
   - Auto Scaling with AMI backups.  

3. **Database Tier**:  
   - Multi-AZ RDS instance (MySQL/PostgreSQL).  
   - Separate subnets for high availability.  

## Features  
- Automatically creates AMIs for backup during instance changes.  
- Fully reusable and modular design.  
- Supports horizontal scaling and high availability.  

Contributions and suggestions are welcome!  