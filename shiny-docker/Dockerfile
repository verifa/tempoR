# base image 
FROM verifa/shiny-base:latest

ARG TEMPO_RENVIRON
COPY ${TEMPO_RENVIRON} /home/shiny/.Renviron

COPY shinyapps /srv/shiny-server/.

USER shiny
 