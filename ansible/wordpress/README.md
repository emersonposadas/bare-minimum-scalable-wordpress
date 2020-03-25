```
[webserver]
EIP  ansible_port=22 ansible_user='ec2-user' ansible_ssh_private_key_file='KeyPath'

```
### - Run the playbook

```
ansible-playbook -i hosts wordpress.yml --extra-vars "target=54.191.63.140"
```
