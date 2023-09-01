#!/usr/bin/env sh
set -e

echo "Retrieving Docker Credentials for the AWS ECR Registry ${AWS_ACCOUNT}"
DOCKER_REGISTRY_SERVER=https://${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
DOCKER_USER=AWS
DOCKER_PASSWORD=`aws ecr get-login --region ${AWS_REGION} --registry-ids ${AWS_ACCOUNT} | cut -d' ' -f6`

echo
echo "Working in Namespace ${NAMESPACE_NAME}"
echo
echo "Removing previous secret in namespace ${NAMESPACE_NAME}"
kubectl --namespace=${NAMESPACE_NAME} delete secret aws-registry || true

echo "Creating new secret in namespace ${NAMESPACE_NAME}"
kubectl create secret docker-registry aws-registry \
	--docker-server=$DOCKER_REGISTRY_SERVER \
	--docker-username=$DOCKER_USER \
	--docker-password=$DOCKER_PASSWORD \
	--docker-email=no@email.local \
	--namespace=${NAMESPACE_NAME}
echo
echo