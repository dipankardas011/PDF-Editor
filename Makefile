testing:
	cd test/unit && \
	chmod 700 backend.sh && \
	./backend.sh

clean:
	sudo docker compose down

build:
	chmod +x build.sh && \
	./build.sh

run:
	sudo docker compose up -d
	docker ps

publish:
	docker push dipugodocker/pdf-editor:frontend
	docker push dipugodocker/pdf-editor:backend

push_docker:
	docker push dipugodocker/pdf-editor:0.8-frontend
	docker push dipugodocker/pdf-editor:0.8-backend
