all: dist/elm.js dist/index.html dist/sampler-sink.png dist/device.png dist/topology.png

install:
	rsync -av dist/ ${out}/

dist:
	mkdir -p dist

dist/%.png: %.png
	cp -f $< $@

dist/index.html: index.html
	cp index.html dist/index.html

dist/elm.js: Story.elm O2Tutorial.elm DataModel.elm TutorialStyles/Styles.elm dist
	elm-make O2Tutorial.elm --output $@

.PHONY: dist publish
