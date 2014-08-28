# XXX no versioning of the docker image

.PHONY: build push clean test

ifneq ($(NOCACHE),)
  NOCACHEFLAG=--no-cache
endif

build:
	docker build ${NOCACHEFLAG} -t planitar/postgresql .

push:
	docker push planitar/postgresql

clean:
	docker rmi -f planitar/postgresql || true

test:
