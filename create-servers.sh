#!/bin/bash

#creating and finding Ip Addresses of the created instances using jq(jason queary)

NAMES=$@
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-017e1df2e846425e8
DOMAIN_NAME=devopsuday.online
HOSTEDZONE_ID=Z03990411I0C649QQKWA1

#for mysql or mongodb intance_type should be t3.medium and rest of the instances t2.micro

for i in $@
do 
   if [[ $i == "mongodb" || $i == "mysql" ]]
         then
             INSTANCE_TYPE="t3.medium"
         else
             INSTANCE_TYPE="t2.micro"
    fi
    echo " creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo " created instance $i PRIVATE IP ADDRESS is $IP_ADDRESS" 

    aws route53 change-resource-record-sets --hosted-zone-id $HOSTEDZONE_ID --change-batch '
    {
            "Changes": [{
            "Action": "CREATE",
                        "ResourceRecordSet": {
                                    "Name": "'$i.$DOMAIN_NAME'",
                                    "Type": "A",
                                    "TTL": 300,
                                 "ResourceRecords": [{ "Value": "'$IP_ADDRESS'"}]
}}]
}'
done   
