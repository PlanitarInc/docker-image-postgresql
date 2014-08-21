# XXX no versioning of the docker image

.PHONY: build push clean test

build:
	docker build -t planitar/postgresql .

push:
	docker push planitar/postgresql

clean:
	docker rmi -f planitar/postgresql

test:
