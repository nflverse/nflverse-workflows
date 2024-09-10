# CODE EXTRACTED FROM nflreadr

#' Get Latest Season
#'
#' A helper function to choose the most recent NFL season
#'
#' @param roster Either `TRUE` or `FALSE`.
#' If `TRUE`, will return current year after March 15th, otherwise previous year.
#' If `FALSE`, will return current year on or after Thursday following Labor Day,
#' i.e. Thursday after the first Monday in September. Otherwise previous year.
#'
#' @return most recent season (a four digit numeric)
#' @export
#' @examples
#' get_current_season()
get_current_season <- function(roster = FALSE) {
  today <- Sys.Date()
  current_year <- as.integer(format(today, format = "%Y"))
  current_month <- as.integer(format(today, format = "%m"))
  current_day <- as.integer(format(today, format = "%d"))
  # First Monday of September
  labor_day <- get_labor_day(current_year)
  # Thursday following Labor Day is TNF season opener
  season_opener <- labor_day + 3

  if ((isFALSE(roster) && today >= season_opener) ||
      (isTRUE(roster) && current_month == 3 && current_day >= 15) ||
      (isTRUE(roster) && current_month > 3 )) {

    return(current_year)
  }

  current_year - 1
}

#' Get Current Week
#'
#' A helper function that returns the upcoming NFL regular season week based on
#' date the number of weeks since the first Monday of September (Labor Day).
#' This will count a new week starting on Thursdays.
#'
#' @examples
#' get_current_week()
#'
#' @return current nfl regular season week as a numeric
#' @export
#' @examples
#' get_current_week()
get_current_week <- function() {

  # Find first Monday of September in current season
  labor_day <- get_labor_day(get_current_season())

  # NFL season starts 3 days later
  first_game <- labor_day + 3

  # current week number of nfl season is 1 + how many weeks have elapsed since first game
  current_week <- as.numeric(Sys.Date() - as.Date(first_game)) %/% 7 + 1

  # hardcoded week bounds because this whole date based thing has assumptions anyway
  if(current_week < 1) current_week <- 1
  if(current_week > 22) current_week <- 22

  current_week
}

#' Compute Date of Labor Day
#'
#' Computes the date of the Labor Day, i.e. the first Monday in September, in a given year.
#'
#' @param year Numeric or Character year. 4 Digits.
#'
#' @export
#' @return Object of Class `Date`
#' @examples
#' # 2023 Labor Day was on Sep 4th
#' compute_labor_day(2023)
get_labor_day <- function(year){
  stopifnot(length(year) == 1)
  earliest <- as.Date(paste(year, "09", "01", sep = "-"))
  latest <- as.Date(paste(year, "09", "08", sep = "-"))
  range <- seq(earliest, latest, by = "day")
  numeric_wdays <- as.POSIXlt(range)$wday
  labor_day <- range[numeric_wdays == 1][1]
  labor_day
}
