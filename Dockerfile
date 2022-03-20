# Base shiny image
FROM docker.io/rocker/shiny-verse:latest AS base

## create directories
RUN mkdir -p /packages

## copy files
COPY install_packages.R /packages/install_packages.R

## install R-packages
RUN Rscript /packages/install_packages.R

# Metrics dashboard
FROM base

ARG TEMPO_RENVIRON
COPY ${TEMPO_RENVIRON} /home/shiny/.Renviron

WORKDIR /srv/shiny-server
RUN rm -rf /opt/shiny-server/samples
RUN rm -rf *
COPY . .

ENV PORT 3838

USER shiny

CMD ["/usr/bin/shiny-server"]
