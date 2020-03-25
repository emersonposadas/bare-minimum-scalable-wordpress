#!/bin/bash
set -x

#
# Load personal AWS API keys
#
export AWS_PROFILE=personal
cd aws_resources/ec2/wordpress
terraform apply --auto-approve

#
# configure the wordpress EC2 instance
#
cd ../../ansible/wordpress
git checkout hosts
AWSWEBIP=$(aws ec2 describe-instances --filter "Name=tag:Name,Values=hkw-web-instance" | grep PublicIpAddress | awk -F ":" '{print $2}' | sed 's/[",]//g' | awk {'print $NF'})
sed -i "s/WEBIP/$AWSWEBIP/g" hosts
ansible-playbook -i hosts wordpress.yml --extra-vars "target=$AWSWEBIP"
