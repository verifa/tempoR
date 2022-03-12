# tempoR

shiny-tempo.Rmd is a shiny R Markdown document. For more details on using R Markdown see http://rmarkdown.rstudio.com.

This uses the tempo [Rest API](https://help.tempo.io/cloud/en/tempo-server-migration-guide/rest-apis-for-your-migration/rest-apis-for-jira-cloud.html) and R to create a dynamic report of the working hours reported in tempo.

The ambition is to include plots necessary to support both a sustainable way of working as well as a simple tool to monitor the activities in tempo.

## Install

- [R](https://www.r-project.org/)
- [Rstudio](https://www.rstudio.com/)
- [pandoc](https://pandoc.org/)

### Dependencies

Currently [arbetsdagar.se](https://arbetsdagar.se) is used to determine the expected work time for the duration that is reported. To use that you have to create an account and create an API key.
### Configuration

To be able to run a document in R there are, at the moment, 3 environment variables that are needed to be set in the `.Renviron` file in your home directory.

```
# tempo
TEMPO_KEY=<your api key for tempo>
TEMPO_START=<the day you started reporting time in tempo, e.g. 2021-08-01>
# arbetsdagar.se
ARBETSDAGAR_KEY=<the created api key> 
```

Then there is one optional variable that is possible to use to control what is presented when you run the markdown file.

```r
TEMPO_DAILY <- Sys.getenv("TEMPO_DAILY")
# No checking for this, can be set this way, or through a config/workinghours.csv file
# TEMPO_DAILY is the needed working ours per day, assuming a 5 day work week
```

When you run the document, a dropdown menu is presented, where the teams with readable data are selectable for viewing.
#### Configuration files

Instead of using TEMPO_DAILY to set the working hours / working day, a csv file in the `shiny/config` folder can be used.

The expected name is `workinghours.csv`, which is a simple csv file with 2 columns and one row per user, that will be used when comparing a users reported working hours with the expected amount of working hours.

```
user, daily
<name>, <number of hours>
....
```

This is to enable a separate private repository for sensitive information.

## Usage

### Rstudio

Open `tempoR.Rproj` in Rstudio and then open the `shiny/shiny-tempo.Rmd` file, then a *Run Document* button appears that is used to view the report in a pop-up window. Running the document this way uses the shiny server included in Rstudio.

### docker

There are two ways for running this in a docker based shiny server

**Test and development:**

The `dev` target in the `Makefile` will run the base image with the shiny files mounted. This is intended as a way to test that the base image has the needed R packages and as a way to check that the running document looks as intended. For this the `.Renviron` file in `${HOME}`is used by default.

```
	docker run --rm -p 3838:3838 \
		-v ${PWD}/shiny/:/srv/shiny-server/ \
		-v ${PWD}/.Renviron:/home/shiny/.Renviron \
		-u shiny \
		$(BASE_IMAGE)

```
**For publication:**

The `build` make target will build a docker image that contains the necessary file to run standalone.

Then there is a `push` target in the Makefile that will push the image to the Artifact registry in google cloud.

To run the `tempo-dashboard` locally there is a `run` target in the Makefile, which will use port 3838 on localhost. 

### Utility scripts

In the `scripts` folder there are a few shell scripts that use `curl` to query tempo and `jq` to parse the result. These scripts also rely on that the tempo api key can be read from `${HOME}/.Renviron`.

#### teams.sh

This presents a list of team names and team id's

#### team-logs.sh

This takes a team id as argument and present the data read for that team.
