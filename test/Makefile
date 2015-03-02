.PHONY: test

test:
	for i in *.sh; do \
	  ./$$i || { echo 'Test $i failed'; false; }; \
	done
