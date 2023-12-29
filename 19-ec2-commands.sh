#!/bin/bash

# Set your AWS region
AWS_REGION="us-east-1"
##clearing data before inserting data
rm -rf /tmp/ins_running.txt
rm -rf /tmp/ins_id_name.txt

# Use AWS CLI to get running EC2 instances
instance_ids=$(aws ec2 describe-instances --region $AWS_REGION --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text >/tmp/ins_running.txt)

# Loop through instance IDs and get instance names
for instance_id in $(cat /tmp/ins_running.txt); do
    instance_name=$(aws ec2 describe-tags --region $AWS_REGION --filters "Name=resource-id,Values=$instance_id" "Name=key,Values=Name" --query "Tags[0].Value" --output text >>/tmp/ins_id_name.txt)
done

for each_component in $(cat /tmp/ins_id_name.txt)
do
  echo ${each_component}
done


