#!/bin/bash
## creating ec2 instances for roboshop-application

AMI_ID="ami-03265a0778a880afb"
SG_ID="sg-002c9cdb8a04c9b4c"
INSTANCES=("mongo" "redis" "mysql" "rabbitmq" "user" "catalogue" "user" "cart" "shipping" "payment" web")

for each_instance in ${INSTANCES[@]}
  do
   
     if [ $each_instance == "mongo" ] || [ $each_instance == "shipping" ] || [ $each_instance == "mysql" ] 
       then
          INSTANCE_TYPE="t3.small"
       else
          INSTANCE_TYPE="t2.micro"

     fi        
    echo "instance name is $each_instance"
    aws2 ec2 run-instances --image-id $AMI_ID --instance-type t2.micro --security-group-ids $SG_ID --region us-east-1 -tags Key=Balaji,Value=$each_instance
    
done 