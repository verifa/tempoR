
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


.PHONY: shiny-test
shiny-test: shiny-base 
	mkdir -p shiny-apps
	cp $(INDEX_FILE) shiny-apps/index.html
	mkdir -p shiny-apps/shiny
	cp $(SHINY_FILES) shiny-apps/shiny/.
	mkdir -p shiny-apps/shiny/config
	cp $(CONFIG_FILES) shiny-apps/shiny/config/.
	docker run --rm -p 3838:3838 \
    -v ${PWD}/shiny-apps/:/srv/shiny-server/ \
    -v ${HOME}/.Renviron:/home/shiny/.Renviron \
    -u shiny \
    $(ORGANISATION)/shiny-base
