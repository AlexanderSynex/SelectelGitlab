## Prerequisites

### Terraform

#### Vars

`domain_name` - Domain name of gitlab instance
`tenant_id` - Selectel Project ID
`user_name` - Username of selectel control panel
`password` - Password of selectel control panel
`gitlab_public_ip` - Domain name public ip
`ssh_key_file` - Path to ssh key for remote access
`gitlab_user_data_path` - Path to file with user_data content

```sh
# Generating gitlab's user_data-config
cat << EOF > ./terraform/metadata.cfg
#cloud-config

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

gitlab_user_data_path = "./metadata.cfg"
EOF
```

## Using

### Create instances

```sh
cd ./terraform
terrafrom init
terrafrom validate && terraform apply -auto-approve || terraform destroy -auto-approve
```

Terraform will generate `inventory.ini` file (`../ansible/resources/inventory.ini`) with gitlab's public ip.

### Create users

Write users' fullnames in `./ansible/resources/users.txt` file in format: 1 line - 1 user name:

```txt
Steven Seagal
Yuri Borisov
```

To run ansible:
```sh
cd ./ansible
ansible-playbook playbook.yaml
```

After creating users ansible will generate users' credentials in yaml format `user-creds.yaml` (`./ansible/resources/user-creds.yaml`) with logins,emails and passwords for every user specified in `users.txt`.
