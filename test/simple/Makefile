.PHONY: test

test:
	docker build -t postgres-simple-test .
	docker run -ti --rm postgres-simple-test; res=$$?; \
	docker rmi postgres-simple-test; exit $$res
