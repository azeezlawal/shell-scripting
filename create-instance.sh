#!/bin/bash
# https://docs.aws.amazon.com/cli/index.html
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-launch-templates.html


#Specify Launch Template ID and version
LID="lt-0ebfe9effc70e8e15"
LVER=2
INSTANCE_NAME=$1

if [ -z "${INSTANCE_NAME}" ]; then
  echo "Input is missing"
  exit 1
fi


#Determine teh state of instances
aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" | jq .Reservations[].Instances[].State.Name | grep running &>/dev/null
if [ $? -eq 0 ]; then
  echo "Instance $INSTANCE_NAME is already running"
  exit 0
fi

aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" | jq .Reservations[].Instances[].State.Name | grep stopped &>/dev/null
if [ $? -eq 0 ]; then
  echo "Instance $INSTANCE_NAME is already created and stopped"
  exit 0
fi
#Launch an instance and get its IP Address
IP=$(aws ec2 run-instances --launch-template LaunchTemplateId=$LID,Version=$LVER --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')


HostedZoneId=$(aws route53 list-hosted-zones | jq '.HostedZones[] | "\(.Id)"' | sed -e 's/\"/\s/g' | sed 's/[^0-9|A-Z]//g')
sed -e "s/INSTANCE_NAME/$INSTANCE_NAME/" -e "s/INSTANCE_IP/$IP/" record.json >/tmp/record.json
aws route53 change-resource-record-sets --hosted-zone-id $HostedZoneId --change-batch file:///tmp/record.json | jq
