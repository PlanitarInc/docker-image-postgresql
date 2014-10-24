.PHONY: test

test:
	docker build -t postgres-exts-test .
	docker run -ti --rm postgres-exts-test; res=$$?; \
	docker rmi postgres-exts-test; exit $$res
