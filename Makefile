testing:
	cd test/unit && \
	chmod 700 backend.sh && \
	./backend.sh

build:
	chmod +x build.sh && \
	./build.sh 0

run: build
	cd deploy/IAC/ansible-terraform/ && \
	sudo docker compose up -d
	docker ps

clean:
	cd deploy/IAC/ansible-terraform/ && \
	sudo docker compose down
	docker ps
	docker volume rm ansible-terraform_app_data_M
	docker volume rm ansible-terraform_app_data_R

unit-test:
	cd test/unit && \
	chmod +x ./unit-tester.sh && \
	./unit-tester.sh

integration-test:
	cd test/integration && \
	chmod +x test-merger.sh && \
	./test-merger.sh

local-deploy-no-cd:
	kubectl cluster-info
	kubectl create ns monitoring
	kubectl create ns pdf-editor-ns
	helm install prom prometheus-community/kube-prometheus-stack -n monitoring
	cd deploy/cluster && \
		kubectl create -k backend && \
		kubectl create -k frontend && \
		kubectl create -f monitoring
	helm upgrade --install loki-stack grafana/loki-stack --set fluent-bit.enabled=true,promtail.enabled=false -n monitoring
	echo "\nLoki URL for grafana datasource addition: http://loki-stack-headless:3100\nPrometheus URL for grafana datasource addition: http://prom-kube-prometheus-stack-prometheus:9090\nJaeger URL for grafana datasource addition: http://trace.pdf-editor-ns:16686"

local-uninstall-no-cd:
	kubectl cluster-info
	cd deploy/cluster && \
		kubectl delete -k backend && \
		kubectl delete -k frontend && \
		kubectl delete -f monitoring
	helm uninstall prom -n monitoring
	helm uninstall loki-stack -n monitoring
	kubectl delete ns monitoring
	kubectl delete ns pdf-editor-ns


publish:
	docker push dipugodocker/pdf-editor:frontend
	docker push dipugodocker/pdf-editor:backend-merge
	docker push dipugodocker/pdf-editor:backend-rotate
	docker push dipugodocker/pdf-editor:backend-db

push_docker:
	docker push dipugodocker/pdf-editor:0.8-frontend
	docker push dipugodocker/pdf-editor:0.8-backend
