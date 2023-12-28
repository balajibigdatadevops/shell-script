#!/bin/bash

AMI_ID=ami-03265a0778a880afb
SG_ID=sg-002c9cdb8a04c9b4c
INSTANCES=("mongo" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
ZONE_ID=Z0216330F2XRXARU66P1
DOMAIN_NAME="balajibigdatadevops.online"


for i in "${INSTANCES[@]}"
do
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ] 
    then
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
		
	TAKE_PRIVATE_IP=$(aws --region us-east-1 ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[PrivateIpAddress, PublicIpAddress]' --output text | awk -F " " '{print $1}')
	
	echo "instance Name $INSTANCES: PrivateIpAddress i.e $TAKE_PRIVATE_IP"	
    
    #create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$TAKE_PRIVATE_IP'"
            }]
        }
        }]
    }
		
	if [ $i == "web" ]
	then
	   INSTANCE_TYPE="t2.micro"
	   
	   IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
		
	TAKE_PUBLIC_IP=$(aws --region us-east-1 ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[PrivateIpAddress, PublicIpAddress]' --output text | awk -F " " '{print $2}')
	
	echo "instance Name $INSTANCES: PrivateIpAddress i.e $TAKE_PRIVATE_IP"	
    
    #create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$TAKE_PUBLIC_IP'"
            }]
        }
        }]
    }
	
        '
done