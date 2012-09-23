build:
	rm -rf lib/
	node_modules/.bin/coffee -o lib/ -cb src/

test:
	npm test
	
.PHONY: test
