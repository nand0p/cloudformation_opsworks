#!/bin/bash

envVarTest1=$(env|grep WWW_VPC_CIDR |cut -f2 -d=)
envVarTest2=$(env|grep WWW_PUBLIC1_CIDR |cut -f2 -d=)
envVarTest3=$(env|grep WWW_PUBLIC2_CIDR |cut -f2 -d=)
envVarTest4=$(env|grep WWW_TRUSTED_IP |cut -f2 -d=)
envVarTest5=$(env|grep WWW_OPSWORKS_ROLE_ARN |cut -f2 -d=)
envVarTest6=$(env|grep WWW_OPSWORKS_PROFILE_ARN |cut -f2 -d=)
if [ -z "$envVarTest1" ] || 
   [ -z "$envVarTest2" ] || 
   [ -z "$envVarTest3" ] || 
   [ -z "$envVarTest4" ] || 
   [ -z "$envVarTest5" ] || 
   [ -z "$envVarTest6" ]
then
    echo
    echo "Environment variables must be set: "
    echo 
    echo "WWW_VPC_CIDR"
    echo "WWW_PUBLIC1_CIDR"
    echo "WWW_PUBLIC2_CIDR"
    echo "WWW_TRUSTED_IP"
    echo "WWW_OPSWORKS_ROLE_ARN"
    echo "WWW_OPSWORKS_PROFILE_ARN"
    echo
    exit
fi
stackName="www-$(date +%Y%m%d-%H%M)"
cfnFile="file://www.json"
title="www vpc creation"
clear
echo
echo "$title $stackName launch script"
echo
echo
echo "create $stackEC2 key-pair"
privateKeyValue=$(aws ec2 create-key-pair --key-name $stackName --query 'KeyMaterial' --output text)
echo
echo
echo "load variables"
echo
echo
cfnParameters=" ParameterKey=wwwStackName,ParameterValue=$stackName "
cfnParameters+=" ParameterKey=vpcCIDR,ParameterValue=$WWW_VPC_CIDR "
cfnParameters+=" ParameterKey=public1CIDR,ParameterValue=$WWW_PUBLIC1_CIDR "
cfnParameters+=" ParameterKey=public2CIDR,ParameterValue=$WWW_PUBLIC2_CIDR "
cfnParameters+=" ParameterKey=wwwTrustedIP,ParameterValue=$WWW_TRUSTED_IP "
cfnParameters+=" ParameterKey=opsworksRoleARN,ParameterValue=$WWW_OPSWORKS_ROLE_ARN "
cfnParameters+=" ParameterKey=opsworksProfileARN,ParameterValue=$WWW_OPSWORKS_PROFILE_ARN "
cfnParameters+=" ParameterKey=KeyName,ParameterValue=$stackName "
echo $cfnParameters
echo
echo
echo "launch www stack"
echo
echo
aws cloudformation create-stack --stack-name $stackName --template-body $cfnFile --parameters "ParameterKey=PrivateKey,ParameterValue=$privateKeyValue" $cfnParameters
echo
echo
echo "wait for stack"
sleep 10
echo
echo
echo "Write out private key $stackName.pem"
echo
echo
aws cloudformation describe-stacks --stack-name $stackName|grep PrivateKey -A22|cut -f3 > $stackName.pem
chmod 0400 -c $stackName.pem
echo
echo
