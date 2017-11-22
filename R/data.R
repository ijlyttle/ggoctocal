#' Sample data-indexed dataset.
#'
#' Daily downloads from RStudio CRAN mirror for __ggplot2__ and __dplyr__ for
#' the years 2015 and 2016.
#'
#' @format A data frame with 1462 observations of 3 variables:
#' \describe{
#'   \item{date}{`Date`, date of the observation}
#'   \item{package}{`character`, name of the package}
#'   \item{count}{`integer`, number of downloads according to the RStudio logs}
#' }
#' @source Downloaded using the
#'   [cranlogs](https://CRAN.R-project.org/package=cranlogs) package.
"cran_sample"
