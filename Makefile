# Build everything with `make`. Requires Python >= 3.10 and Typst >= 0.15.
PYTHON ?= python3
TYPST  ?= typst

.PHONY: all data test verify paper poster check clean

all: data paper poster

data:                        ## regenerate data/processed from data/raw
	cd analysis && $(PYTHON) -m woodlab build

test:                        ## run the analysis test suite
	cd analysis && $(PYTHON) -m unittest discover -s tests

verify: data                 ## regenerate docs/VERIFICATION.md
	$(PYTHON) analysis/verify_original.py

paper: build/paper.pdf
poster: build/poster.pdf

build/%.pdf: %.typ lib/*.typ $(wildcard paper/*.typ poster/*.typ) data/processed/*.csv | build
	$(TYPST) compile $< $@

build:
	mkdir -p build

check: test                  ## tests + confirm committed processed data is current
	cd analysis && $(PYTHON) -m woodlab build
	git diff --exit-code -- data/processed docs

clean:
	rm -rf build
