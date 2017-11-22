CRAN downloads
================

The [cranlogs packge]() will be super-useful for us to create some sample daily-data.

``` r
library("lubridate")
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
library("tibble")
library("dplyr")
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:lubridate':
    ## 
    ##     intersect, setdiff, union

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library("cranlogs")
```

This is a fake dataset to test a fake model to determine if a day is a weekend. Our dataset will include two years of dates.

``` r
cran_sample <- 
  cran_downloads(
    packages = c("ggplot2", "dplyr"),
    from = "2015-01-01",
    to = "2016-12-31"
  ) %>%
  transmute(
    date,
    package,
    count = as.integer(count)
  ) %>% 
  as_tibble()
```

``` r
print(cran_sample)
```

    ## # A tibble: 1,462 x 3
    ##          date package count
    ##        <date>   <chr> <int>
    ##  1 2015-01-01 ggplot2   817
    ##  2 2015-01-02 ggplot2  1218
    ##  3 2015-01-03 ggplot2  1063
    ##  4 2015-01-04 ggplot2  1106
    ##  5 2015-01-05 ggplot2  2171
    ##  6 2015-01-06 ggplot2  2455
    ##  7 2015-01-07 ggplot2  2739
    ##  8 2015-01-08 ggplot2  2732
    ##  9 2015-01-09 ggplot2  2661
    ## 10 2015-01-10 ggplot2  1451
    ## # ... with 1,452 more rows

| Variable  | Type        | Description                                        |
|-----------|-------------|----------------------------------------------------|
| `date`    | `Date`      | date of the observation                            |
| `package` | `character` | name of the package                                |
| `count`   | `integer`   | number of downloads, according to the RStudio logs |

Write it out
------------

``` r
devtools::use_data(cran_sample, overwrite = TRUE)
```

    ## Saving cran_sample as cran_sample.rda to /Users/ijlyttle/Documents/git/github/public_work/septimr/data
