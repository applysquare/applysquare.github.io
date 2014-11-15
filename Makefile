.PHONY: all
all: html js css

.PHONY: html
html:
	cd _html && make

.PHONY: js
js:
	cd _js && make

.PHONY: css
css:
	cd _css && make

.PHONY: clean
clean:
	cd _html && make clean
	cd _js && make clean
	cd _css && make clean
	find . -iname \*~ -exec rm -f {} \;
	find . -iname \*.pyc -exec rm -f {} \;

.PHONY: watch
watch: all
	@while inotifywait -e modify -r -qq _js _css _html; do \
		echo; echo; echo; \
		make; \
	done

