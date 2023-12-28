#!/bin/bash

## creating ec2 instances for roboshop-application

AMI_ID=ami-03265a0778a880afb
SG_ID=sg-002c9cdb8a04c9b4c
INSTANCES=("mongo" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")
ZONE_ID=Z0216330F2XRXARU66P1
DOMAIN_NAME="balajibigdatadevops.online"
ADDRESS=("Private" "Public")

instance_create_route53()
		{
		Private_Address=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-087e7afb3a936fce7 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
		
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
				"Value"         : "'$Private_Address'"
            }]
        }
        }]
    }
		}

for i in "${INSTANCES[@]}"
do
   for each_address in "${ADDRESS}"
    do
    if [[ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ] ] && [ $each_address == "Private" ]
    then
        INSTANCE_TYPE="t3.small"
		
		##calling function
	    instance_create_route53
    		  
	elif [ $i == "web" ] && [ $each_address == "Public" ]
	INSTANCE_TYPE="t2.micro"
	Public_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-087e7afb3a936fce7 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PublicIpAddress' --output text)
		
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
				"Value"         : "'$Public_ADDRESS'"
            }]
        }
        }]
    }
   else
      INSTANCE_TYPE="t2.micro"
	  ##calling function
	  instance_create_route53
	fi
	done
done