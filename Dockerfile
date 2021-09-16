FROM verifa/rbase-metrics

# prepare the workspace
RUN mkdir -p /code

## run the script
CMD cd /code && Rscript  -e "rmarkdown::render('tempo.Rmd')"
