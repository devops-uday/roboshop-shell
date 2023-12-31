#!/bin/bash

#creating and finding Ip Addresses of the created instances using jq(jason queary)

NAMES=("mongoDB" "Reddis" "MySQL" "RabbitMQ" "Catalouge" "User" "cart" "Shipping" "Payment" "Dispatch" "Web")
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-017e1df2e846425e8

#for mysql or mongodb intance_type should be t3.medium and rest of the instances t2.micro

for i in "${NAMES[@]}"
do 
   if [[ $i == "mongoDB" || $i == "MySQL" ]]
         then
             INSTANCE_TYPE="t3.medium"
         else
             INSTANCE_TYPE="t2.micro"
    fi
    echo " creating $i instance"
    IP_ADDRESS=$(aws ec2 run-instances --image-id $IMAGE_ID --instance-type $INSTANCE_TYPE --security-group-ids $SECURITY_GROUP_ID --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo " created instance $i PRIVATE IP ADDRESS is $IP_ADDRESS" 
done    
