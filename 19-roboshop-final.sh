#!/bin/bash


AMI_ID=ami-03265a0778a880afb
SG_ID=sg-002c9cdb8a04c9b4c
INSTANCES=("mongo" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
ZONE_ID=Z0216330F2XRXARU66P1
DOMAIN_NAME="balajibigdatadevops.online"
PRIVATE=PrivateIpAddress
PUBLIC=PublicIPAddress


##defining function to create instance and create or update A record for roboshop components
instance_route53_func()
{
    If [ $PRIVATE == "PrivateIpAddress" ]
	then
	IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].$Private' --output text)
	
	Take_private_IP=$(aws --region us-east-1 ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[PrivateIpAddress, PublicIpAddress]' --output text | awk -F " " '{print $1}')
	
	echo "Displaying Private address"
    echo "$each_address: $IP_ADDRESS"
    
    #create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$each_address'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$Take_private_IP'"
            }]
        }
        }]
    }
	else 
	
    IP_ADDRESS=$(aws ec2 run-instances --image-id $AMI_ID --instance-type $INSTANCE_TYPE --security-group-ids $SG_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].$Private' --output text)
	
	Take_public_IP=$(aws --region us-east-1 ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query 'Reservations[*].Instances[*].[PrivateIpAddress, PublicIpAddress]' --output text | awk -F " " '{print $2}')
	
	echo "Displaying Public address"
    echo "$i: $IP_ADDRESS"

    #create R53 record, make sure you delete existing record
    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "UPSERT"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$each_address'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$Take_public_IP'"
            }]
        }
        }]
    }
	
	fi
}


for i in "${INSTANCES[@]}"
do      
   
	if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ] && [ $each_address == "private_ip" ]
    then
       INSTANCE_TYPE="t3.small"
	   instance_route53_func
	elif [ $i == "web" ] && [ $each_address == "public_ip" ]
	INSTANCE_TYPE="t2.micro"
	instance_route53_func
	else
	INSTANCE_TYPE="t2.micro"
	instance_route53_func
	 fi	

 done




   
    