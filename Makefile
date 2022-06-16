testing:
	cd test/unit && \
	chmod 700 backend.sh && \
	./backend.sh

clean:
	cd src/backend/ && \
	rm backend