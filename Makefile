##
##    tempoR Makefile
##    ###############
##
## Builds 2 different docker images for the tempo data shiny-base and shiny-server
## 
## shiny-base:   is a shiny server instance adding the R packages needed for tempo
## shiny-server: adds the tempo R files to the shiny-base image for a selfcontained image
##
## shiny-test:   is a test target that mounts the R files to the shiny-base image for testing
##
ORGANISATION ?= verifa

INDEX_FILE := shiny-index.html
CONFIG_FILES := $(wildcard config/*.csv)
SHINY_FILES := shiny-tempo.Rmd $(wildcard *.R)

TEMPO_RENVIRON ?= $(HOME)/.Renviron

default: shiny-server

##
## Targets
##
## help          : prints this help
.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<

## clean         : removes the proxy files, shiny-base and shiny-server
.PHONY: clean
clean:
	@rm -f shiny-base shiny-server

## shiny-base    : builds a docker image w the necessary R packages
shiny-base: shiny-docker/Dockerbase shiny-docker/install_packages.R Makefile
	cd shiny-docker && docker build -f Dockerbase -t $(ORGANISATION)/$@ .
	touch $@

## shiny-files   : list the files added to the server
.PHONY : shiny-files
shiny-files:
	@echo 
	@echo "INDEX_FILE:   $(INDEX_FILE)"
	@echo "CONFIG_FILES: $(CONFIG_FILES)"
	@echo "SHINY_FILES:  $(SHINY_FILES)"
	@echo ".Renviron:    $(TEMPO_RENVIRON)"

## shiny-server  : builds a docker images for publication, 
##               : that contains our shiny files and configuration files
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

## shiny-test    : runs the shiny base image, 
##               : with the R files mounted for testing
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
