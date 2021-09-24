# Base image https://hub.docker.com/u/rocker/
FROM rocker/r-base:latest

## install debian packages and pandoc
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
libxml2-dev \
libcairo2-dev \
libsqlite3-dev \
libmariadbd-dev \
libpq-dev \
libssh2-1-dev \
unixodbc-dev \
libcurl4-openssl-dev \
libssl-dev \ 
pandoc

## create directories
RUN mkdir -p /packages

## copy files
COPY install_packages.R /packages/install_packages.R

## install R-packages
RUN Rscript /packages/install_packages.R

# prepare the workspace
RUN mkdir -p /code

## run the script
CMD cd /code && Rscript  -e "rmarkdown::render('tempo.Rmd')"
