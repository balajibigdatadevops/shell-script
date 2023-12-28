#!/bin/bash


AMI_ID=ami-03265a0778a880afb
SG_ID=sg-002c9cdb8a04c9b4c
INSTANCES=("mongo" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
ZONE_ID=Z0216330F2XRXARU66P1
DOMAIN_NAME="balajibigdatadevops.online"
ADDRESS=("private_ip" "public_ip")
Private="PrivateIpAddress"
Public="PublicIPAddress"


##defining function to create instance and create or update A record for roboshop components
instance_route53_func()
{
   for each_address in ${ADDRESS[@]}
   do
    If [[ $Private == "PrivateIpAddress" ]]
	then
	IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-087e7afb3a936fce7 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].$Private' --output text)
    
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
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
	elif [ $Public == "PublicIPAddress" ]
	IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-087e7afb3a936fce7 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].$Public' --output text)
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
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
	
	fi
	
	
	done
}


for i in "${INSTANCES[@]}"
do      
    for each_address in "${ADDRESS[@]}"
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
 done




   
    