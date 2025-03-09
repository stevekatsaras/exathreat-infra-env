# Requirements
This project was designed to work with terraform version **1.0**
This project only needs to be run **once per region**

# To run:
- `./deploy.sh us-east-1`
- When the plan is done, `terraform apply "tfplan"`

# To destroy:
- `./deploy.sh us-east-1 -destroy`
- When the plan is done, `terraform apply "tfplan"`
