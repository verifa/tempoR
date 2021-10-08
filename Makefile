
ORGANISATION ?= verifa


default: tempo.html


.PHONY: rbase-metrics
rbase-metrics:
	cd $@ && docker build -t $(ORGANISATION)/$@ .

.PHONY: tempo.html
tempo.html: rbase-metrics
	@echo Generating $@ with $^
	@docker run -v ~/.Renviron:/root/.Renviron -v ${PWD}:/code $(ORGANISATION)/$^
