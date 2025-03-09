# Requirements
This project was designed to work with terraform version **1.0**

# To run:
- `./deploy.sh live ap-southeast-2`
- When the plan is done, `terraform apply "tfplan"`

# To destroy:
- `./deploy.sh live ap-southeast-2 -destroy`
- When the plan is done, `terraform apply "tfplan"`

# VPC Setup

The VPC is based on a multi-tier architecture across 2 availability zones. This was chosen as it allows for flexibiltiy, and scalability. This allows the scaling of each individual layer separately on demand. There is no need to scale the Database layer if only the Web layer requires scaling. Furthermore, it decouples the application, meaning that an outage in one layer may not result on an outage in all the other layers. 
The tiers are as follows:
1. Public layer: This is where a bastion host will sit along with a public facing load balancer.
2. Public Web Layer: This is where all the front end application logic sits, HTML, CSS, etc.
3. Private Database Layer: This is where your databases live.

# CIDR Blocks

The VPC is designed around a CIDR block of 10.50.0.0/16. This was chosen as it allows for 256 IP addresses (/24 blocks) for all 4 layers across all 3 availabilty zones, with room to grow to a fourth availability zone. However, should you only want 2 availability zones, this can be changed to 10.240.0.0/21, with the relevant changes being made to remove 1 availability zone from each of the subnets.

# Network ACLs 

A Decision was made to block all from the public network ACL and only open up specific CIDR blocks and ports on demand. This meant that we could allow all from the Private ACL, thus managing all traffic via the public ACL.

# Security Groups

The Public layer Security group is set to allow all traffic in and all traffic out. This would be the security group that is used by the bastion host and public load balancers. 

The Private layer security groups allow all traffic out and only ssh access in from the CIDR block of the VPC. This ingress rule is only inteded as a starting rule to allow any future landing boxes to have access.

# Availability Zones

The VPC has been set up for 2 Availability Zones, however the number of availabiltiy zones can be changed by adding or removing corresponding letters from the list variable `azs`. For example, if we modify the variable to

```
variable "azs" {
    type = list
    default = ["a", "b", "c"]
}
```

it will deploy 3 availability zones, a, b and c. However if availability zone d is added in the future and we want to add it, assuming we've added the subnet mappings to the `cidr` value, we can modify the variable to the following and it will deploy to 4 availability zones.

```
variable "azs" {
    type = list
    default = ["a", "b", "c", "d"]
}
```

Alternatively the variable can be set via the var flag when using terraform plan and apply. For example:

``` 
terraform plan -var 'azs=["a" ,"b", "c"]'
```

# Other Info

Availability zones can be controlled by a variable, see explanation under Availability Zones heading

An internet gateway has been set up to route traffic from the public subnets. 