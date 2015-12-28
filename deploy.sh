#!/bin/bash

clear
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
    echo "WWW_VPC_CIDR: $envVarTest1"
    echo "WWW_PUBLIC1_CIDR: $envVarTest2"
    echo "WWW_PUBLIC2_CIDR: $envVarTest3"
    echo "WWW_TRUSTED_IP: $envVarTest4"
    echo "WWW_OPSWORKS_ROLE_ARN: $envVarTest5"
    echo "WWW_OPSWORKS_PROFILE_ARN: $envVarTest6"
    echo
    exit
fi
keyName=www
stackName="www-$(date +%Y%m%d-%H%M)"
cfnFile="file://cloudformation.json"
echo
echo "$stackName :: $cfnFile"
echo
echo
echo "==> create $keyName key-pair:"
aws ec2 delete-key-pair --key-name $keyName
privateKeyValue=$(aws ec2 create-key-pair --key-name $keyName --query 'KeyMaterial' --output text)
echo
echo
echo "==> load variables:"
echo
echo
cfnParameters=" ParameterKey=wwwStackName,ParameterValue=$stackName "
cfnParameters+=" ParameterKey=vpcCIDR,ParameterValue=$WWW_VPC_CIDR "
cfnParameters+=" ParameterKey=public1CIDR,ParameterValue=$WWW_PUBLIC1_CIDR "
cfnParameters+=" ParameterKey=public2CIDR,ParameterValue=$WWW_PUBLIC2_CIDR "
cfnParameters+=" ParameterKey=wwwTrustedIP,ParameterValue=$WWW_TRUSTED_IP "
cfnParameters+=" ParameterKey=opsworksRoleARN,ParameterValue=$WWW_OPSWORKS_ROLE_ARN "
cfnParameters+=" ParameterKey=opsworksProfileARN,ParameterValue=$WWW_OPSWORKS_PROFILE_ARN "
cfnParameters+=" ParameterKey=KeyName,ParameterValue=$keyName "
echo $cfnParameters
echo
echo "==> launch opsworks stack:"
echo
echo
aws cloudformation create-stack --stack-name $stackName --disable-rollback --template-body $cfnFile --parameters "ParameterKey=PrivateKey,ParameterValue=$privateKeyValue" $cfnParameters
echo
echo
echo "==> wait for stack:"
sleep 5
echo
echo
echo "==> Write out private key $keyName.pem:"
echo
echo
rm -fv $keyName.pem
aws cloudformation describe-stacks --stack-name $stackName|grep PrivateKey -A22|cut -f3 > $keyName.pem
chmod -c 0400 $keyName.pem
echo
echo
