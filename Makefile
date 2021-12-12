
ORGANISATION ?= verifa

INDEX_FILE := shiny-index.html
CONFIG_FILES := $(wildcard config/*.csv)
SHINY_FILES := shiny-tempo.Rmd $(wildcard *.R)

TEMPO_RENVIRON ?= $(HOME)/.Renviron

$(info $(SHINY_FILES))
$(exit)

default: shiny-server

shiny-base: shiny-docker/Dockerbase shiny-docker/install_packages.R Makefile
	cd shiny-docker && docker build -f Dockerbase -t $(ORGANISATION)/$@ .
	touch $@

shiny-server: shiny-base shiny-docker/Dockerfile Makefile $(SHINY_FILES) $(INDEX_FILE) $(CONFIG_FILES)
	cp $(TEMPO_RENVIRON) shiny-docker/Renviron
	mkdir -p shiny-docker/shinyapps
	cp $(INDEX_FILE) shiny-docker/shinyapps/index.html
	mkdir -p shiny-docker/shinyapps/shiny
	cp $(SHINY_FILES) shiny-docker/shinyapps/shiny/.
	mkdir -p shiny-docker/shinyapps/shiny/config
	cp $(CONFIG_FILES) shiny-docker/shinyapps/shiny/config/.
	cd shiny-docker && docker build --build-arg TEMPO_RENVIRON=Renviron --no-cache -t $(ORGANISATION)/$@ .
	touch $@

.PHONY: rbase-metrics
rbase-metrics:
	cd $@ && docker build -t $(ORGANISATION)/$@ .
