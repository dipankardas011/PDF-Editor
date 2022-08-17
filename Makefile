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

unit-test:
	cd test/unit && \
	chmod +x ./unit-tester.sh && \
	./unit-tester.sh

integration-test:
	cd test/integration && \
	chmod +x test-merger.sh && \
	./test-merger.sh

publish:
	docker push dipugodocker/pdf-editor:frontend
	docker push dipugodocker/pdf-editor:backend-merge
	docker push dipugodocker/pdf-editor:backend-rotate
	docker push dipugodocker/pdf-editor:backend-db

push_docker:
	docker push dipugodocker/pdf-editor:0.8-frontend
	docker push dipugodocker/pdf-editor:0.8-backend
