# base image 
FROM docker.io/rocker/shiny-verse:latest


## create directories
RUN mkdir -p /packages

## copy files
COPY install_packages.R /packages/install_packages.R

## install R-packages
RUN Rscript /packages/install_packages.R
