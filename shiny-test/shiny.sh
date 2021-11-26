#!/bin/sh -e

pushd $(dirname ${0})
TEMPO_DOCS="tempo.html"
SHINY_DOCS="shiny-tempo.Rmd r-helpers.R data-helpers.R ggplot-helpers.R arbetsdag.R"
SHINY_INDEX="shiny-index.html"

if [ ! -f "../tempo.html" ]; then
  pushd ..
  make
  popd
fi

pushd ..
make shiny-base
popd

for doc in ${TEMPO_DOCS}; do
  cp ../${doc} shinyapps/.
done

for doc in ${SHINY_DOCS}; do
  mkdir -p shinyapps/shiny
  cp ../${doc} shinyapps/shiny/.
done

cp ../${SHINY_INDEX} shinyapps/index.html

if [ -d ../config ]; then
  mkdir -p shinyapps/shiny/config
  cp ../config/* shinyapps/shiny/config/.
fi

docker run --rm -p 3838:3838 \
    -v ${PWD}/shinyapps/:/srv/shiny-server/ \
    -v ${HOME}/.Renviron:/home/shiny/.Renviron \
    -u shiny \
    verifa/shiny-base

popd
