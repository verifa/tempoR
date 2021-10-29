#!/bin/sh

pushd $(dirname ${0})
SHINY_DOCS="tempo.html"

if [ ! -f "../tempo.html" ]; then
  pushd ..
  make
  popd
fi

for doc in ${SHINY_DOCS}; do
  cp ../${doc} shinyapps/.
done

docker run --rm -p 3838:3838 \
    -v ${PWD}/shinyapps/:/srv/shiny-server/ \
    -u shiny \
    docker.io/rocker/shiny-verse

popd
