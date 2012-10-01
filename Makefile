build:
	node_modules/.bin/coffee -o lib -cb src

clean:
	rm -rf lib/*
	
test:
	npm test
	
.PHONY: build clean test
