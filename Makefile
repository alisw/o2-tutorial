all: dist/elm.js dist/index.html dist/sampler-sink.png dist/device.png dist/topology.png dist/pure-min.css

install:
	rsync -av dist/ ${out}/

dist:
	mkdir -p dist

dist/%.png: %.png
	cp -f $< $@

dist/index.html: index.html
	cp index.html dist/index.html

dist/pure-min.css: pure-min.css 
	cp pure-min.css dist/pure-min.css

dist/elm.js: Story.elm O2Tutorial.elm DataModel.elm TutorialStyles/Styles.elm dist
	elm-make O2Tutorial.elm --yes --output $@

.PHONY: dist publish
