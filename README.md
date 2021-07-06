# Architecture
![Test Image](https://github.com/pumvanilla/terraform_test/blob/main/image1.jpg)

## AWS key
```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
```
```
add public key
https://github.com/pumvanilla/terraform_test/blob/fc83ffaace0722d482abced38a3727c4e75c1417/key.tf#L5
```

## Install Terraform
```
brew install terraform
```

## Execute Terraform
```
terraform init
terraform plan
terraform apply --auto-approve
terraform output -json > web/config.json
```

## VPC setting
```
name : prod-vpc
subnet
public : 10.0.1.0/24
private-zone a : 10.0.4.0/24 -> web
private-zone b : 10.0.5.0/24 -> db
```

## security group setting
```
- web
name : web traffic
ingress open port : 80(http), 443(https), 22(ssh), 8080(web)
egress open to any

- database
name : sg rds
ingress port : 5432
egress open to any
```

## expected output
```
access web through eip
and show data from rdb
```
### Example output

![alt text](https://github.com/pumvanilla/terraform_test/blob/main/example_output.png)


# Build & Deploy

```
Infrastructure by TerraformCloud
Web by Github action
```