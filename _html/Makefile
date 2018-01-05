DIR = ..
SOURCES = $(shell find . -type f -not -name .\* -name \*.haml)
TARGETS = $(patsubst ./%.haml, $(DIR)/%, $(SOURCES))

.PHONY: all
all: $(TARGETS)

$(DIR)/%: %.haml
	@mkdir -p `dirname $@`
	@rm -f $@
	@echo "$< => $@"
	@haml  --no-escape-attrs --double-quote-attributes $< $@

.PHONY: clean
clean:
	find .. -path ../_site -prune -o -iname \*.html -exec rm -f {} \;
