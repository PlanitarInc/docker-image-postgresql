.PHONY: test

test:
	docker build -t postgres-override-test .
	docker run -ti --rm postgres-override-test; res=$$?; \
	docker rmi postgres-override-test; exit $$res
