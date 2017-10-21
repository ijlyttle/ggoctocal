context("decompose")

library("lubridate")
library("tibble")
library("dplyr")

test_that("weekday-conversion works", {

  # sunday, sunday, tuesday, saturday, saturday
  weekday_nam <- c(1L, 1L, 3L, 7L, 7L)
  weekday_iso <- c(7L, 7L, 2L, 6L, 6L)

  expect_identical(.wday_nam_to_iso(weekday_nam), weekday_iso)
  expect_identical(.wday_iso_to_nam(weekday_iso), weekday_nam)

})

test_that("decompose functions work", {

  dates <-
    c("2009-12-31", "2010-01-01",
      "2014-12-31", "2015-01-01",
      "2017-12-31", "2018-01-01") %>%
    as.Date()

  # ISO
  #  2010 begins on a Friday (5);
  #    2009-12-31 belongs to last week (53) of 2009
  #    2010-01-01 belongs to last week (53) of 2009
  #  2015 begins on a Thursday (4)
  #    2014-12-31 belongs to the first week (1) of 2015
  #    2015-01-01 belongs to the first week (1) of 2015
  #  2018 begins on a Monday (1)
  #    2017-12-31 belongs to the last week (52) of 2017
  #    2018-01-01 belongs to the first week (1) of 2018
  #
  decompose_iso <- tribble(
    ~.year, ~.week, ~.wday,
    2009L,  53L,    4L,
    2009L,  53L,    5L,
    2015L,   1L,    3L,
    2015L,   1L,    4L,
    2017L,  52L,    7L,
    2018L,   1L,    1L
  )

  # NAM
  #  2010 begins on a Friday (6);
  #    2009-12-31 belongs to last week (53) of 2009
  #    2010-01-01 belongs to first week (1) of 2010
  #  2015 begins on a Thursday (5)
  #    2014-12-31 belongs to the last week (53) of 2015
  #    2015-01-01 belongs to the first week (1) of 2015
  #  2018 begins on a Monday (2)
  #    2017-12-31 belongs to the last week (53) of 2017
  #    2018-01-01 belongs to the first week (1) of 2018
  #
  decompose_nam <- tribble(
    ~.year, ~.week, ~.wday,
    2009L,  53L,    5L,
    2010L,   1L,    6L,
    2014L,  53L,    4L,
    2015L,   1L,    5L,
    2017L,  53L,    1L,
    2018L,   1L,    2L
  )

  expect_error(decompose_date(dates, "foo"))
  expect_identical(decompose_date(dates, "iso"), decompose_iso)
  expect_identical(decompose_date(dates, "nam"), decompose_nam)

  df_dates <- tibble(date = dates)
  df_nam <- bind_cols(df_dates, decompose_nam)
  df_iso <- bind_cols(df_dates, decompose_iso)

  expect_identical(mutate_decompose_date(df_dates, week_style = "nam"), df_nam)
  expect_identical(mutate_decompose_date(df_dates, week_style = "iso"), df_iso)

})
