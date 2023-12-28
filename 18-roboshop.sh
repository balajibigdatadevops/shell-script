#!/bin/bash
## creating ec2 instances for roboshop-application

AMI_ID=ami-03265a0778a880afb
SG_ID=sg-002c9cdb8a04c9b4c
INSTANCES=("mongo" "redis" "mysql" "rabbitmq" "user" "catalogue" "user" "cart" "shipping" "payment" "web")

for each_instance in "${INSTANCES[@]}"
  do
     echo "instance name is ${each_instance}"
   
     if [ $each_instance == "mongo" ] || [ $each_instance == "shipping" ] || [ $each_instance == "mysql" ] 
       then
          INSTANCE_TYPE="t3.small"
       else
          INSTANCE_TYPE="t2.micro"
     fi       
 
    aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID 
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Balaji,Value=$each_instance}]'
 done 