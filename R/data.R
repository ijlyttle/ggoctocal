#' Sample data-indexed dataset.
#'
#' A dataset to use to test data-based visualizations.
#'
#' @format A data frame with 731 observations of 5 variables:
#' \describe{
#'   \item{date}{`Date`, date of the observation}
#'   \item{observation}{`character`, indicates if this is a "weekend" or "weekday"}
#'   \item{probability}{`double`, "model" probability that this is a "weekend"}
#'   \item{prediction}{`character`, "model" prediction of type of day}
#'   \item{strength}{`double`, "model" probability that this is a "weekend"}
#' }
"data_weekend"
