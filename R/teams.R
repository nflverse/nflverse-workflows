#' Get NFL team abbreviations
#'
#' @inheritParams get_current_season
#'
#' @returns An array of team abbreviations (character)
#' @export
#'
#' @examples
#' get_teams()
#' get_teams(as_json = TRUE)
get_teams <- function(as_json = !interactive()){
  format_output(teams, as_json = as_json)
}
