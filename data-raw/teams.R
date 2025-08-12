teams <- nflreadr::load_teams() |>
  dplyr::pull(team_abbr)
usethis::use_data(teams, overwrite = TRUE, internal = TRUE)
