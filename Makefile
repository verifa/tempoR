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

TEMPO_RENVIRON ?= $(HOME)/.Renviron

default: shiny-server

##
## Targets
##
## help	       : prints this help
.PHONY : help
help : Makefile
	@sed -n 's/^##//p' $<

## build-base    : builds a docker image w the necessary R packages
build-base:
	docker build --target base -t $(BASE_IMAGE) .

## build         : builds a docker images for publication that contains our
##	       : shiny files and configuration files
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
		-v ${PWD}/index.html:/srv/shiny-server/index.html \
		-v ${PWD}/shiny/:/srv/shiny-server/shiny/ \
		-v ${PWD}/.Renviron:/home/shiny/.Renviron \
		-u shiny \
		$(BASE_IMAGE)

## run           : runs the tempo-dashboard locally
run: build
	docker run --rm -p 3838:3838 $(IMAGE):$(TAG)
