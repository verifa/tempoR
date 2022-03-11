workingdays <- function(begins, ends, key) {
  result <- c()
  for (i in seq(length.out=length(begins))) {
    # working days
    WD_URL = "http://api.arbetsdag.se/v2/dagar.json"
    WD_QUERY = paste0("?fran=", as.Date(begins[i]),
                      "&till=", as.Date(ends[i]),
                      "&key=", key,
                      "&id=1234")
    url = paste0(WD_URL, WD_QUERY)
    
    WD <- fromJSON(url)
    result[i] <- WD$antal_vardagar
  }
  return(result)
}
