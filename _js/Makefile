APPLYSQUARE_TARGET = applysquare.js
APPLYSQUARE_SOURCES = \
	debug.js \
	jquery/jquery.livequery.js \
	jquery/jquery.imagesloaded.js \
	jquery/jquery.pjax.coffee.js \
	jquery/jquery.autotimestamp.coffee.js \
	applysquare/applysquare.coffee.js \
	applysquare/applysquare.utils.coffee.js \
	applysquare/applysquare.language.coffee.js \
	applysquare/applysquare.cover.coffee.js \
	applysquare/applysquare.post.coffee.js \

.PHONY: all
all:  ../static/js/$(APPLYSQUARE_TARGET)

../static/js/$(APPLYSQUARE_TARGET): $(APPLYSQUARE_TARGET)
	mkdir -p ../static/js
	cat $(APPLYSQUARE_TARGET) | yui-compressor --type js > ../static/js/$(APPLYSQUARE_TARGET)

$(APPLYSQUARE_TARGET): $(APPLYSQUARE_SOURCES)
	cat $(APPLYSQUARE_SOURCES) > $(APPLYSQUARE_TARGET)

%.coffee.js: %.coffee
	cat $< | coffee -c -s > $<.js

.PHONY: clean
clean:
	find . -iname \*.coffee.js -exec rm -f {} \;
	rm -f $(APPLYSQUARE_TARGET)
	rm -f ../static/js/$(APPLYSQUARE_TARGET)
