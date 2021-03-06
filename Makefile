testing:
	cd test/unit && \
	chmod 700 backend.sh && \
	./backend.sh

clean:
	sudo docker compose down

build:
	chmod +x build.sh && \
	./build.sh 0

run:
	cd deploy/IAC/ansible-terraform/
	sudo docker compose up -d
	docker ps

publish:
	docker push dipugodocker/pdf-editor:frontend
	docker push dipugodocker/pdf-editor:backend-merge
	docker push dipugodocker/pdf-editor:backend-rotate
	docker push dipugodocker/pdf-editor:backend-db

push_docker:
	docker push dipugodocker/pdf-editor:0.8-frontend
	docker push dipugodocker/pdf-editor:0.8-backend
