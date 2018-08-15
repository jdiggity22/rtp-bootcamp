#!/bin/bash
## --------------------------------------------------------------------------------------------------
## ICP login script to authenticate and connect to and IBM Cloud Private (ICP) environment
## Provided by IBM Cloud Private Center of Competency team
## --------------------------------------------------------------------------------------------------

ICPHOST=https://172.16.247.198
ICPUSER=admin
ICPPASSWORD="admin"
ICPCLUSTER=mycluster
ICPNAMESPACE=default

echo Retrieving security token for user: $ICPUSER at host: $ICPHOST
## get the id token
TOKEN=$(curl -s -X POST $ICPHOST:8443/idprovider/v1/auth/identitytoken -H "Content-Type: application/x-www-form-urlencoded;charset=UTF-8" -d "grant_type=password&username=$ICPUSER&password=$ICPPASSWORD&scope=openid%20email%20profile" --insecure | jq --raw-output .id_token)

echo
echo Setting kubectl enviroment
echo
## execute kubectl commands to connect to ICP environment
kubectl config set-cluster $ICPCLUSTER --server=$ICPHOST:8001 --insecure-skip-tls-verify=true
kubectl config set-context $ICPCLUSTER-context --cluster=$ICPCLUSTER
kubectl config set-credentials $ICPUSER --token=$TOKEN
kubectl config set-context $ICPCLUSTER-context --user=$ICPUSER --namespace=$ICPNAMESPACE
kubectl config use-context $ICPCLUSTER-context

echo
echo "Try kubectl get pods"
echo
