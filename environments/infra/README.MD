# Requirements
This project was designed to work with terraform version **1.0**

# To run:
- `./deploy.sh live ap-southeast-2`
- If you want to modify the api lambda lb target-group attachment to api2, then run: `./deploy.sh live ap-southeast-2 -var="active_lambda=2"`
- If you want to modify it back to api1 then use the normal `./deploy.sh live ap-southeast-2`
- When the plan is done, `terraform apply "tfplan"`

# To destroy:
- `./deploy.sh live ap-southeast-2 -destroy`
- When the plan is done, `terraform apply "tfplan"`
