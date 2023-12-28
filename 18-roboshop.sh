#!/bin/bash
## creating ec2 instances for roboshop-application

AMI_ID=ami-03265a0778a880afb
SG_ID=sg-002c9cdb8a04c9b4c
INSTANCES=("mongo" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
ZONE_ID=Z0216330F2XRXARU66P1
DOMAIN_NAME="balajibigdatadevops.online"

for each_instance in "${INSTANCES[@]}"
  do
     echo "instance name is ${each_instance}"
   
     if [ $each_instance == "mongo" ] || [ $each_instance == "shipping" ] || [ $each_instance == "mysql" ] 
       then
          INSTANCE_TYPE="t3.small"
       else
          INSTANCE_TYPE="t2.micro"
     fi       
 
    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$each_instance}]" --query 'Instances[0].PrivateIpAddress' --output text)
   
   aws route53 change-resource-record-sets --hosted-zone-id $ZONE_ID  --change-batch '{ "Comment": "creating a record set", "Changes": [ { "Action": "CREATE","ResourceRecordSet": { "Name": "'$each_instance'.'$DOMAIN_NAME'", "Type": "A", "TTL": 1, "ResourceRecords": [ { "'Value'": "'$IP_ADDRESS'" } ] } } ] }'
   
 done 