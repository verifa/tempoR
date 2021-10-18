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
### Configuration

To be able to knit a document in R there are, at the moment, 3 environment variables that are needed to be set in the `.Renviron` file in your home directory.

```
# tempo
TEMPO_KEY=<your api key for tempo>
TEMPO_START=<the day you started reporting time in tempo, e.g. 2021-08-01>
# arbetsdagar.se
ARBETSDAGAR_KEY=<the created api key> 
```

Then there are a couple of variables that is possible to use to control the generated report

```r
TEMPO_DAILY <- Sys.getenv("TEMPO_DAILY")
# No checking for this, can be set this way, or through a config/workinghours.csv file
# TEMPO_DAILY is the needed working ours per day, assuming a 5 day work week
TEMPO_DETAILS <- Sys.getenv("TEMPO_DETAILS")
# No checking for this, used to filter how much details are plotted
```

There is also a variable, `TEMPO_TEAM`, that can be used to use the entries for a specific team in tempo. If this is missing from the environment, the teams are read from tempo and the results for each team where the data is accessible will be present in the report. If this variable is set to a specific team id, the report will only contain that team and as a final option, if this is set to '0' the report will ignore teams in tempo and simply present the data which is accessible for the used TEMPO_KEY. There is a [script](####teams.sh) in the `scripts` folder to help see what teams are configured in tempo.

#### Configuration files

Instead of using TEMPO_DAILY to set the working hours / working day, a csv file in the `config` folder can be used.

The expected name is `workinghours.csv`, which is a simple csv file with 2 columns and one row per user, that will be used when comparing a users reported working hours with the expected amount of working hours.

```
user, daily
<name>, <number of hours>
....
```

This is to enable a separate private repository for sensitive information.

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

### Utility scripts

In the `scripts` folder there are a few shell scripts that use `curl` to query tempo and `jq` to parse the result. These scripts also rely on that the tempo api key can be read from `${HOME}/.Renviron`.

#### teams.sh

This presents a list of team names and team id's

#### team-logs.sh

This takes a team id as argument and present the data read for that team.
