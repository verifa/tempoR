##
##	tempoR Makefile
##	###############
##
## Builds 2 different docker images for the tempo data shiny-base and shiny-server
## 
## build-base:   is a shiny server instance adding the R packages needed for tempo
## build: adds the tempo R files to the shiny-base image for a selfcontained image
##
## dev:   is a dev mode that mounts the R files to the shiny-base image for testing
##
REPO := europe-north1-docker.pkg.dev/verifa-metrics/tempo
TAG := $(shell git describe --tags --always --dirty=-dev)
IMAGE := $(REPO)/tempo-dashboard

# Hardcoded because we don't push this anywhere
BASE_IMAGE := verifa/shiny-base:test

INDEX_FILE := shiny-index.html
CONFIG_FILES := $(wildcard config/*.csv)
SHINY_FILES := shiny-tempo.Rmd $(wildcard *.R)

TEMPO_RENVIRON ?= $(HOME)/.Renviron

default: shiny-server

##
## Targets
##
## help	         : prints this help
.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<

## clean         : removes the proxy files, shiny-base and shiny-server
.PHONY: clean
clean:
	@rm -f shiny-base shiny-server

## build-base    : builds a docker image w the necessary R packages
build-base:
	docker build --target base -t $(BASE_IMAGE) .

## shiny-files   : list the files added to the server
.PHONY : shiny-files
shiny-files:
	@echo 
	@echo "INDEX_FILE:   $(INDEX_FILE)"
	@echo "CONFIG_FILES: $(CONFIG_FILES)"
	@echo "SHINY_FILES:  $(SHINY_FILES)"
	@echo ".Renviron:	$(TEMPO_RENVIRON)"

## build         : builds a docker images for publication that contains our
##	             : shiny files and configuration files
build:
	# If .Renviron exists locally, use it, otherwise fetch from home directory
	# or the file set by TEMPO_RENVIRON
	if [ ! -f .Renviron ]; then \
		cp $(TEMPO_RENVIRON) .Renviron; \
	fi
	docker build --build-arg TEMPO_RENVIRON=.Renviron -t $(IMAGE):$(TAG) .

push: build
	docker push $(IMAGE):$(TAG)
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest
	docker push $(IMAGE):latest

## dev           : runs the base docker image and mounts local files for dev mode
dev: build-base
	docker run --rm -p 3838:3838 \
		-v ${PWD}/shiny/:/srv/shiny-server/ \
		-v ${PWD}/.Renviron:/home/shiny/.Renviron \
		-u shiny \
		$(BASE_IMAGE)

