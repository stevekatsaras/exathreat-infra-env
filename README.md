exathreat-infra-env
-------------------
A TerraForm script that create and/or destroys an entire Exathreat environment (network, subnets, security groups, databases, etc) in the AWS cloud. Required before deploying Exathreat applications to the cloud.

1. exathreat-infrastructure: run "terraform apply".
2. exathreat-db: connect via MySQLWorkbench and run "assets/setup-rds-database.sql"
3. exathreat-api: run "deploy.sh" via the exathreat-api GIT repo.
4. 
5. 