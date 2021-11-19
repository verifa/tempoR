# ggplot-helpers

tempo.daily.plot <- function(data, id) {
  # returns
  # a column plot with the daily logs for each
  # user in the team, colors follow the project keys
  #
  # data is the aggregated data for all teams
  # id is the team.id for one team
  #
  plot <- ggplot(data = subset(data, team == id)) +
    geom_col(aes(x = date, y = hours, fill = key)) +
    facet_wrap(~user) + scale_fill_hue(l = 45) +
    scale_y_continuous(
      breaks = c(0,2,4,6,8,10),
      name = "Daily",
      sec.axis = dup_axis()) +
    scale_x_date(name = NULL) +
    theme(legend.position = "top",
          axis.text.x = element_text(size = 6, angle = 45, hjust = 1)) +
    ggtitle("Daily logs")
  
  return(plot)
}

tempo.detailed.plot <- function(data, id) {
  # returns
  # a detailed column plot with the daily logs for each
  # user in the team, colors follow the project tasks
  # limited to the last 14 days
  #
  # data is the aggregated data for all teams
  # id is the team.id for one team
  #
  plot <- ggplot(data = subset(data, team == id)) +
    geom_col(aes(x = date, y = hours, fill = issue.key), show.legend = FALSE) +
    facet_wrap(~user) + scale_fill_hue(l = 45) +
    scale_y_continuous(
      breaks = c(0,2,4,6,8,10),
      name = "Daily",
      sec.axis = dup_axis()) +
    scale_x_date(name = NULL) +
    theme(legend.position = "top",
          axis.text.x = element_text(size = 6, angle = 45, hjust = 1)) +
    coord_cartesian(xlim = c(Sys.Date() - 14, Sys.Date())) +
    ggtitle("Detailed logs, last 14 days")
  
  return(plot)
}

tempo.billable.plot <- function(data) {
  # returns a scatter plot of the billable tasks
  # 
  # data is user.detail
  #
  plot <- ggplot(data = subset(data, billable > 0)) +
    geom_point(aes(x = reorder(issue.key, -hours),
                   y = hours,
                   color = issue.key,
                   fill = issue.key), show.legend = FALSE) +
    facet_wrap(~user) + scale_fill_hue(l = 45) +
    scale_x_discrete(name = NULL) +
    scale_y_log10(
      name = "Logged hours [h]",
      sec.axis = dup_axis()) +
    theme(legend.position = "top",
          legend.title = element_blank(),
          axis.text.x = element_text(size = 6, angle = 45, hjust = 1)) +
    ggtitle("Billable tasks")
  
  return(plot)
}

tempo.unbillable.plot <- function(data) {
  # returns a detailed scatter plot for the unbillable tasks
  #
  # 
  plot <- ggplot(data = subset(data, billable == 0)) +
    geom_point(aes(x = reorder(issue.key, -hours),
                   y = hours,
                   color = issue.key,
                   fill = issue.key), show.legend = FALSE) +
    facet_wrap(~user) + scale_fill_hue(l = 45) +
    scale_x_discrete(name = NULL) +
    scale_y_log10(
      name = "Logged hours [h]",
      sec.axis = dup_axis()) +
    theme(legend.position = "top",
          axis.text.x = element_text(size = 6, angle = 45, hjust = 1)) +
    ggtitle("Unbillable tasks")
  
  return(plot)
}

team.plot <- function(data) {
  plot <- ggplot(data = data) +
    geom_point(aes(x = date, y = average.7.hours), color = "Gray50", shape = 1) +
    geom_point(aes(x = date, y = average.30.hours), color = "Dark Blue") +
    geom_smooth(aes(x = date, y = average.30.hours), color = "Dark Blue") +
    geom_point(aes(x = date, y = average.7.billable), color = "Gray75", shape = 1) +
    geom_point(aes(x = date, y = average.30.billable), color = "Dark Green") +
    geom_smooth(aes(x = date, y = average.30.billable), color = "Dark Green") +
    scale_color_hue(l = 45) + scale_fill_hue(l = 45) +
    scale_y_continuous(
      breaks = c(0,8,16,24,32,40, 48,56), 
      name = "Weekly", 
      sec.axis = dup_axis()) +
    scale_x_date(name = NULL) +
    theme(legend.position = "top",
          legend.title = element_blank(),
          axis.text.x = element_text(size = 6, angle = 45, hjust = 1))
  
  return(plot)
}

rolling.plot <- function(data) {
  plot <- ggplot(data = data) +
    geom_point(aes(x = date, y = roll.7.hours), color = "Gray50", shape = 1) +
    geom_point(aes(x = date, y = roll.7.billable), color = "Gray75", shape = 1) +
    geom_point(aes(x = date, y = roll.30.hours), color = "Dark Blue") +
    geom_line(aes(x = date, y = roll.30.hours), color = "Dark Blue") +
    geom_point(aes(x = date, y = roll.30.billable), color = "Dark Green") +
    geom_line(aes(x = date, y = roll.30.billable), color = "Dark Green") +
    facet_wrap(~user) + scale_fill_hue(l = 45) + scale_color_hue(l = 45) +
    scale_y_continuous(
      breaks = c(0,8,16,24,32,40, 48), 
      name = "Rolling Weekly [h]", 
      sec.axis = dup_axis()) +
    scale_x_date(name = NULL) +
    theme(legend.position = "top", legend.title = element_blank(),
          axis.text.x = element_text(size = 6, angle = 45, hjust = 1))
  
  return(plot)
}

accumulated.plot <- function(data) {
  plot <- ggplot(data = data) +
    geom_col(aes(x = user, y = delta, fill = user), show.legend = FALSE) +
    scale_fill_hue(l = 45) +
    scale_x_discrete(name = NULL) +
    scale_y_continuous(
      name = "Delta hours [h]",
      sec.axis = dup_axis())
  
  return(plot)
}
