#
# r helpers
#
# for a few helper functions
#

check.if.empty <- function(var, name) {
  if (var == "") {
    stop.message <- paste(name, "is not defined")
    stop(stop.message)
  }
}

check.packages <- function(package.list) {
  for (package in package.list) {
    tryCatch(find.package(package),
             error = function(e) {
               print(paste("Please install", package, "for this to work"))
             })
  }
}

capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
                           {s <- substring(s, 2); if(strict) tolower(s) else s},
                           sep = "", collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

