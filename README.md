## Prerequisites

### Terraform

#### Vars

`domain_name` - Domain name of gitlab instance
`tenant_id` - Selectel Project ID
`user_name` - Username of selectel control panel
`password` - Password of selectel control panel
`gitlab_public_ip` - Domain name public ip
`ssh_key_file` - Path to ssh key for remote access
`gitlab_user_data_path` - Path to file with gitlab user_data content
`runner_user_data_path` - Path to file with runner user_data content

```sh
# Generating gitlab's user_data-config
cat << EOF > ./terraform/resources/gitlab_metadata.cfg
#cloud-config

timezone: Europe/Moscow

# Start Gitlab Instance
# Configure Gitlab root user and DB
write_files:
- path: "/opt/gomplate/values/user-values.yaml"
  permissions: "0644"
  content: |
    gitlabDomain: "<domain_name>"
    gitlabRootEmail: "<email>"
    gitlabRootPassword: "<password>"
    gitlabPostgresDB: "gitlab"
    gitlabPostgresUser: "gitlab"
    gitlabPostgresPassword: "gitlab"
    useExternalDB: false
EOF

# Generating ssh-key
ssh-keygen -t rsa -C "" -N "" -f ~/.ssh/id_rsa_selectel

# Generating secrets-file
cat << EOF > ./terraform/terraform.tfvars
domain_name = "<domain>"
tenant_id = "<tenant_id>"
password = "<selectel_password>"
user_name = "<selectel_login>"

gitlab_public_ip = "<public_ip>"

ssh_key_file = "~/.ssh/id_rsa_selectel"

gitlab_user_data_path = "../resources/gitlab_metadata.cfg"
runner_user_data_path = "../resources/runner_metadata.cfg"

EOF
```

## Usage

### Create GitLab instance

```sh
cd ./terraform/gitlab
terraform init && \
terraform validate && \
terraform apply -auto-approve -var-file ../terraform.tfvars || terraform destroy -auto-approve && \
cd ../..
```

Terraform will generate `inventory.ini` file (`../ansible/resources/inventory.ini`) with gitlab's public ip.

### Create users

Before executing wait for gitlab to load. You need to see login page on `https://<gitlabDomain>/users/sign_in` before next step.

Write users' fullnames in `./ansible/resources/users.txt` file in format: 1 line - 1 user name:

```txt
Steven Seagal
Yuri Borisov
```

To run ansible:
```sh
cd ./ansible && \
ansible-playbook playbook.yaml && \
cd ..
```

After creating users ansible will generate users' credentials in yaml format `user-creds.yaml` (`./ansible/resources/user-creds.yaml`) with logins,emails and passwords for every user specified in `users.txt`. Moreover, it will generate creds for runners in `runner-creds.yaml` (`./ansible/resources/user-creds.yaml`). And `cloud-init` config  `runner_metadata.cfg` (`./terraform/resources/runner_metadata.cfg`).

### Creating runner instance

This step follows Ansible's step. Terraform will create an instance of Gitlab-Runner for the registered one from [step 1](#create-users)

```sh
cd ./terraform/gitlab-runner
terraform init && \
terraform validate && \
terraform apply -auto-approve -var-file ../terraform.tfvars || terraform destroy -auto-approve && \
cd ..
```
