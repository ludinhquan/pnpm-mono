NAMESPACE=staging
RELEASE=staging
REGISTRY=localhost:32000

build:
	docker build --build-arg GIT_COMMIT=$(shell git rev-parse HEAD) -t $(REGISTRY)/server -f infra/docker/Dockerfile.server .
	docker build --build-arg GIT_COMMIT=$(shell git rev-parse HEAD) -t $(REGISTRY)/client -f infra/docker/Dockerfile.client .
	docker push $(REGISTRY)/server
	docker push $(REGISTRY)/client

setup:
	microk8s config > ~/.kube/config

	microk8s enable hostpath-storage
	microk8s enable cert-manager
	microk8s enable ingress

	# kubectl create secret docker-registry gcr-key \
	#  --docker-server=australia-southeast1-docker.pkg.dev \
	#  --docker-username=_json_key \
	#  --docker-password="$(cat ~/booking-system.json)" \
	#  --docker-email=ludinhquan@gmail.com
	#
	# kubectl patch serviceaccount default \
	# 	-p '{"imagePullSecrets": [{"name": "gcr-key"}]}'
	
install:
	kubectl create namespace $(NAMESPACE)
	kubectl config set-context --current --namespace $(NAMESPACE)
	kubectl apply -f infra/clusterissuer.yaml

	helm dependency update infra/helms
	helm upgrade --install $(RELEASE) infra/helms

clean:
	helm uninstall $(RELEASE)
	kubectl delete pvc datadir-mongodb-0

	kubectl delete namespace $(NAMESPACE)
	kubectl config set-context --current --namespace default
	kubectl delete -f infra/clusterissuer.yaml

upgrade:
	helm upgrade --install $(RELEASE) infra/helms

restart:
	kubectl rollout restart deployment client
	kubectl rollout restart deployment server
