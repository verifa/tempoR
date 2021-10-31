# A set of generic functions that operate on the "aggregated" data
# to produce data formatted for the plots

gen.user.data <- function(data, id) {
  user.data <- subset(data, team == id) %>%
    group_by(date, user, key) %>%
    summarise(
      hours = sum(hours),
      billable = sum(billable)
    )
  return(user.data)
}

gen.user.detail <- function(data, id) {
  user.detail <- subset(data, team == id) %>%
    group_by(user, issue.key) %>%
    summarise(
      hours = sum(hours),
      billable = sum(billable)
    )
  return(user.detail)
}

gen.user.summary <- function(data, id) {
  user.summary <- subset(data, team == id) %>%
    group_by(date, user) %>%
    summarise(
      hours = sum(hours),
      billable = sum(billable)
    ) %>%
    group_by(user) %>%
    mutate(
      cumulative.hours = cumsum(hours),
      cumulative.billable = cumsum(billable),
      roll.7.hours = slide_index_dbl(hours, date, sum, .before = days(6), .complete = TRUE),
      roll.7.billable = slide_index_dbl(billable, date, sum, .before = days(6), .complete = TRUE),
      roll.30.hours = slide_index_dbl(roll.7.hours, date, mean, .before = days(29), .complete = TRUE),
      roll.30.billable = slide_index_dbl(roll.7.billable, date, mean, .before = days(29), .complete = TRUE)
    )
  
  return(user.summary)
}

gen.team.summary <- function(summary) {
  team.summary <- summary %>%
    group_by(date) %>%
    summarise(
      average.7.hours = mean(roll.7.hours, na.rm = TRUE),
      sd.7.hours = sd(roll.7.hours, na.rm = TRUE),
      average.30.hours = mean(roll.30.hours, na.rm = TRUE),
      sd.30.hours = sd(roll.30.hours, na.rm = TRUE),
      average.7.billable = mean(roll.7.billable, na.rm = TRUE),
      sd.7.billable = sd(roll.7.billable, na.rm = TRUE),
      average.30.billable = mean(roll.30.billable, na.rm = TRUE),
      sd.30.billable = sd(roll.30.billable, na.rm = TRUE)
    )
  
  return(team.summary)
}

gen.user.delta <- function(data, id) {
  user.delta <- subset(data, team == id) %>%
    group_by(user) %>%
    summarise(
      start = min(startDate),
      end = max(startDate),
      hours = sum(hours),
      billable = sum(billable)
    )
  
  if (! is.null(working.hours)) {
    user.delta <- merge(user.delta, working.hours, by = "user")
  } else {
    if (TEMPO_DAILY == '') {
      TEMPO_DAILY = 8
    }
    user.delta <- user.delta %>%
      group_by(user) %>%
      mutate(
        daily = as.numeric(TEMPO_DAILY)
      )
  }
  user.delta <- user.delta %>%
    group_by(user) %>%
    mutate(
      expected = daily * workingdays(start, end), 
      delta = hours - expected,
      fraction = 100 * billable / expected
    )
  
  return(user.delta)
}
