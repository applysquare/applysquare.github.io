APPLYSQUARE_TARGET = applysquare.css
APPLYSQUARE_SOURCES = \
	applysquare/applysquare.sass.css \
	syntax.css \

.PHONY: all
all: ../static/css/$(APPLYSQUARE_TARGET)

../static/css/$(APPLYSQUARE_TARGET): $(APPLYSQUARE_TARGET)
	mkdir -p ../static/css
	cat $(APPLYSQUARE_TARGET) | yui-compressor --type css > ../static/css/$(APPLYSQUARE_TARGET)

$(APPLYSQUARE_TARGET): $(APPLYSQUARE_SOURCES)
	cat $(APPLYSQUARE_SOURCES) > $(APPLYSQUARE_TARGET)

%.sass.css: %.sass $(shell find . -type f -iname _\*.sass)
	cat $< | sass --compass --load-path . > $<.css

.PHONY: clean
clean:
	find . -iname \*.sass.css -exec rm -f {} \;
	rm -rf .sass-cache
	rm -f $(APPLYSQUARE_TARGET)
	rm -f ../static/css/$(APPLYSQUARE_TARGET)

