# Architecture
![Test Image](https://github.com/pumvanilla/terraform_testarchitecture.png)

## AWS key
```
export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
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