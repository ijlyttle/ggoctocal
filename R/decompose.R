#' Decompose a date into components
#'
#' TODO - better names for these functions
#'
#' One is used to operate on a vector, the other to operate on a data frame.
#'
#' Talk about ISO weeks, talk about using years.
#'
#' @param date        `Date`, date to decompose
#' @param week_style  `character`, style to use: `"nam"`, `"iso"`
#' @param use_year    `logical`, use `year` as a variable
#'
#' @return [decompose_date]:
#' `tbl_df` with variables:
#' \describe{
#'   \item{.year}{`integer`, year to which the week belongs}
#'   \item{.week}{`integer`, number of week}
#'   \item{.wday}{`integer`, identifies the day in the week}
#' }
#' @export
#'
decompose_date <- function(date, week_style = c("nam", "iso"), use_year = TRUE) {

  week_style <- match.arg(week_style)

  fn <- list(
    nam = .decompose_date_nam,
    iso = .decompose_date_iso
  )

  fn[[week_style]](date)

}

.decompose_date_nam <- function(date) {

  date <- as.Date(date)

  tibble::tibble(
    .year = lubridate::year(date) %>% as.integer(),
    .week = lubridate::week(date) %>% as.integer(),
    .wday = lubridate::wday(date) %>% as.integer()
  )

}


.decompose_date_nam_new <- function(date) {

  date <- as.Date(date)

  data.frame(
    .year = lubridate::year(date) %>% as.integer(),
    .week = lubridate::week(date) %>% as.integer(),
    .wday = lubridate::wday(date) %>% as.integer()
  )

}

.decompose_date_iso <- function(date) {

  date <- as.Date(date)

  dec_nam <- .decompose_date_nam(date)

  # convert nam weekday to iso weeksay
  .wday_iso <- .wday_nam_to_iso(dec_nam$.wday) %>% as.integer()

  .week_iso <- lubridate::isoweek(date) %>% as.integer()

  # adjust year, if needed
  .year_iso <-
    dplyr::case_when(
      # week belongs to following iso year
      (.week_iso < 3L) & (dec_nam$.week > 48L) ~ dec_nam$.year + 1L,
      # week belongs to previous iso year
      (.week_iso > 48L) & (dec_nam$.week < 3L) ~ dec_nam$.year - 1L,
      # iso week and nam week "agree"
      TRUE ~ dec_nam$.year
    ) %>%
    as.integer()

  tibble::tibble(.year = .year_iso, .week = .week_iso, .wday = .wday_iso)
}

.wday_iso_to_nam <- function(x) {
  # key is implied in the index - this is the iso weekday (1-7)
  # value is the value of the nam weekday (1-7)
  key_value <- c(2L, 3L, 4L, 5L, 6L, 7L, 1L)

  key_value[x]
}

.wday_nam_to_iso <- function(x) {
  # key is implied in the index - this is the nam weekday (1-7)
  # value is the value of the iso weekday (1-7)
  key_value <- c(7L, 1L, 2L, 3L, 4L, 5L, 6L)

  key_value[x]
}


#' @rdname decompose_date
#'
#' @param .data `tbl_df` to which to bind new columns
#'
#' @return [mutate_decompose_date()]:
#' `.data`, with additional columns generated using [decompose_date()]
#' @export
#'
mutate_decompose_date <-
  function(.data, date = .data$date, week_style = "nam", use_year = TRUE) {

  decompose <-
    decompose_date(date, week_style = week_style, use_year = use_year)

  dplyr::bind_cols(.data, decompose)
}
