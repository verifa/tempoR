# tempoR

tempo.Rmd is an R Markdown document. For more details on using R Markdown see http://rmarkdown.rstudio.com.

This uses the tempo [Rest API](https://help.tempo.io/cloud/en/tempo-server-migration-guide/rest-apis-for-your-migration/rest-apis-for-jira-cloud.html) and R to create a simple report of the working hours reported in tempo.

The ambition is to include the plot necessary to support both a sustainable way of working as well as a simple tool to monitor the activities in tempo.

## Install

- [R](https://www.r-project.org/)
- [Rstudio](https://www.rstudio.com/)
- [pandoc](https://pandoc.org/)

### Dependencies

Currently [arbetsdagar.se](https://arbetsdagar.se) is used to determine the expected work time for the duration that is reported. To use that you have to create an account and create an API key.
### 

To be able to knit a document in R there are, at the moment, 3 environment variables that are needed to be set in the `.Renviron` file in your home directory.

```
# tempo
TEMPO_KEY=<your api key for tempo>
TEMPO_START=<the day you started reporting time in tempo, e.g. 2021-08-01>
# arbetsdagar.se
ARBETSDAGAR_KEY=<the created api key> 
```

## Usage

### Rstudio

Open `tempoR.Rproj` in Rstudio and then open the `tempo.Rmd` file, then a *Knit* button appears that is used to generate the report `tempo.html' 

### CLI

There is a small `tempo.sh` script included that when executed will generate `tempo.html'

### docker

**To run locally:**

Build [verifa/rbase-metrics](rbase-metrics/Dockerfile) image:
```
$ cd rbase-metrics
$ docker build -t verifa/rbase-metrics .
```

Build [verifa/tempor](Dockerfile) image:
```
$ docker build -t verifa/tempoR .
```

Make sure your .Rneviron is in your home directory and run:
```
$ docker run -v ~/.Renviron:/root/.Renviron -v [path to this repo on your machine]]:/code verifa/tempor
```

**Using the Makefile**

Assuming docker and make are installed, generate the report using make, `tempo.html` is the default target, so all that is needed is `make`
