# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z0-9_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

NAMESPACE=digibank
MICROSERVICES_FOLDER=./microservices

INGRESS_HOST 				:= $(shell kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
INGRESS_IP	 				:= $(shell dig +short ${INGRESS_HOST}| awk '{ print ; exit }')
INGRESS_PORT 				:= $(shell kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
SECURE_INGRESS_PORT := $(shell kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
TCP_INGRESS_PORT 		:= $(shell kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')

HYDRA_SECRETS_SYSTEM=lJmn8CfxU55MMdmuHcBsUhCmClL4qgIu
HYDRA_DSN=postgres://hydra:secret@10.1.1.4:5432/hydra?sslmode=disable

########################
##### DOCKER TASKS #####
########################

docker-build: ## Build all the containers
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) build
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) build
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) build
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) build
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) build
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) build
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) build

docker-build-nc: ## Build all the containers without caching
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) build-nc
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) build-nc
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) build-nc
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) build-nc
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) build-nc
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) build-nc
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) build-nc

docker-release: docker-build-nc docker-publish ## Make a release by building and publishing all `{version}` and `latest` tagged containers
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) release
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) release
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) release
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) release
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) release
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) release
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) release

docker-publish: docker-publish-latest docker-publish-version ## Publish all `{version}` and `latest` tagged containers
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) publish
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) publish
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) publish
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) publish
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) publish
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) publish
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) publish

docker-publish-latest: docker-tag-latest ## Publish all `latest` tagged container
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) publish-latest
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) publish-latest
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) publish-latest
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) publish-latest
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) publish-latest
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) publish-latest
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) publish-latest

docker-publish-version: docker-tag-version ## Publish all `{version}` tagged containers
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) publish-version
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) publish-version
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) publish-version
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) publish-version
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) publish-version
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) publish-version
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) publish-version

docker-tag: docker-tag-latest docker-tag-version ## Generate all container tags for the `{version}` ans `latest` tags
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) tag
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) tag
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) tag
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) tag
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) tag
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) tag
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) tag

docker-tag-latest: ## Generate all containers `{version}` tag
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) tag-latest
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) tag-latest
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) tag-latest
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) tag-latest
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) tag-latest
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) tag-latest
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) tag-latest

docker-tag-version: ## Generate all containers `latest` tag
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) tag-version
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) tag-version
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) tag-version
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) tag-version
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) tag-version
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) tag-version
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) tag-version

docker-stop: ## Stop and remove all running container
	cd ${MICROSERVICES_FOLDER}/accounts && $(MAKE) stop 2>/dev/null || true
	cd ${MICROSERVICES_FOLDER}/authentication && $(MAKE) stop 2>/dev/null || true
	cd ${MICROSERVICES_FOLDER}/bills && $(MAKE) stop 2>/dev/null || true
	cd ${MICROSERVICES_FOLDER}/portal && $(MAKE) stop 2>/dev/null || true
	cd ${MICROSERVICES_FOLDER}/support && $(MAKE) stop 2>/dev/null || true
	cd ${MICROSERVICES_FOLDER}/transactions && $(MAKE) stop 2>/dev/null || true
	cd ${MICROSERVICES_FOLDER}/userbase && $(MAKE) stop 2>/dev/null || true
	docker stop mongo 2>/dev/null ; docker rm mongo 2>/dev/null || true

docker-run: ## Run the full demo with docker-compose
	@echo "Digibank GUI will be available at http://localhost:3000/"
	@echo "Mongo Express GUI will be available at http://localhost:8081/"
	docker-compose up


############################
##### KUBERNETES TASKS #####
############################

k8s_install_digibank: ## Install digibank application
	kubectl create namespace ${NAMESPACE} || true
	kubectl apply -f ./kubernetes --namespace ${NAMESPACE}

k8s_remove_digibank: ## Remove digibank application
	kubectl delete namespace ${NAMESPACE}

k8s_install_digibank_istio: ## Install istio enabled digibank application
	kubectl create namespace ${NAMESPACE} || true
	kubectl label namespace ${NAMESPACE} istio-injection=enabled --overwrite
	kubectl apply -f ./kubernetes --namespace ${NAMESPACE}
	kubectl create secret tls digibank-credential --namespace istio-system \
		--key ./certs/digibank/digibank-key.pem \
		--cert ./certs/digibank/digibank-cert.pem || true
	kubectl apply -f ./istio --namespace ${NAMESPACE}

k8s_remove_digibank_istio: ## Remove istio enabled digibank application
	kubectl delete namespace ${NAMESPACE}
	kubectl delete secret digibank-credential --namespace istio-system

k8s_test_digibank_istio: ## Test istio enabled digibank application
	while true ; do curl -v -HHost:digibank.f5demo.org --resolve "digibank.f5demo.org:${SECURE_INGRESS_PORT}:${INGRESS_IP}" \
		--cacert ./certs/root/root-cert.pem "https://digibank.f5demo.org:${SECURE_INGRESS_PORT}/" ; sleep 1 ; done


######################
##### HELM TASKS #####
######################

helm_install: ## Install digibank application using helm
	kubectl apply -f ./helm/namespace.yaml
	helm install digibank ./helm/digibank --namespace ${NAMESPACE} --values ./helm/digibank/values.yaml

helm_upgrade: ## Upgrade digibank application using helm
	kubectl apply -f ./helm/namespace.yaml
	helm upgrade digibank ./helm/digibank --namespace ${NAMESPACE} --values ./helm/digibank/values.yaml

helm_remove: ## Remove digibank application using helm
	helm uninstall digibank --namespace ${NAMESPACE}
	kubectl delete -f ./helm/namespace.yaml


#######################
##### HYDRA TASKS #####
#######################

hydra_init_db: ## Initialise postgres dbn schema for hydra backend 
	hydra migrate sql --yes ${HYDRA_DSN}

hydra_run_backend: ## Start hydra backend
	sudo docker run -d --net host \
		-e SECRETS_SYSTEM=${HYDRA_SECRETS_SYSTEM} \
		-e DSN=${HYDRA_DSN} \
		-e URLS_SELF_ISSUER=https://10.1.1.4:4444 \
		-e URLS_CONSENT=http://10.1.1.4:3000/consent \
		-e URLS_LOGIN=http://10.1.1.4:3000/login \
		--restart always \
		--name hydra \
		-d oryd/hydra:v1.5.0-alpine serve all

hydra_run_consent_frontend: ## Start hydra frontend consent application
	hydra clients create --endpoint https://10.1.1.4:4445 --skip-tls-verify --id digibank --secret digibank123 --grant-types authorization_code,refresh_token,client_credentials,implicit --response-types token,code,id_token  --scope hydra.consent 
	sudo docker run -d --net host \
		-p 9020:3000 \
		-e HYDRA_URL=https://10.1.1.4:4444 \
		-e HYDRA_CLIENT_ID="digibank" \
		-e HYDRA_CLIENT_SECRET="digibank123" \
		-e NODE_TLS_REJECT_UNAUTHORIZED=0 \
		--name hydra-consent-app \
		-d boeboe/hydra-consent-app-express

hydra_install: hydra_init_db hydra_run_backend hydra_run_consent_frontend  ## Start all hydra setup components and configuration

hydra_clean: ## Remove hydra setup components and configuration
	hydra clients delete --endpoint https://10.1.1.4:4445 digibank --skip-tls-verify 2>/dev/null || true
	sudo docker stop hydra ; sudo docker rm hydra 2>/dev/null || true
	sudo docker stop hydra-consent-app ; sudo docker rm hydra-consent-app 2>/dev/null || true
