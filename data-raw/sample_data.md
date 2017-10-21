Sample data
================

It will be useful to have some sample data.

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

This is a fake dataset to test a fake model to determine if a day is a weekend. Our dataset will include two years of dates.

``` r
set.seed(3.14159)

is_weekend <- function(date) {
  lubridate::wday(date) %in% c(1L, 7L)
}

probability_weekend <- function(obs) {
  
  n_obs <- length(obs)
  
  logodds_weekday <- rnorm(n_obs, mean = -2, sd = 1)
  logodds_weekend <- rnorm(n_obs, mean =  2, sd = 1)
  
  logodds <- dplyr::case_when(
    obs == "weekday" ~ logodds_weekday,
    obs == "weekend" ~ logodds_weekend,
    TRUE ~ NA_real_
  )
  
  odds <- plogis(logodds)
  
  odds
}

data_weekend <- 
  tibble(
    date = seq(as.Date("2015-01-01"), as.Date("2016-12-31"), by = 1),
    observation = case_when(
      is_weekend(date) ~ "weekend",
      TRUE ~ "weekday"
    ),
    probability = probability_weekend(observation),
    prediction = case_when(
      probability > 0.5 ~ "weekend",
      probability <= 0.5 ~ "weekday",
      TRUE ~ NA_character_
    ),
    strength = abs(probability - 0.5) / 0.5
  )
```

``` r
print(data_weekend)
```

    ## # A tibble: 731 x 5
    ##          date observation probability prediction  strength
    ##        <date>       <chr>       <dbl>      <chr>     <dbl>
    ##  1 2015-01-01     weekday  0.04917553    weekday 0.9016489
    ##  2 2015-01-02     weekday  0.09174387    weekday 0.8165123
    ##  3 2015-01-03     weekend  0.77415601    weekend 0.5483120
    ##  4 2015-01-04     weekend  0.92614999    weekend 0.8523000
    ##  5 2015-01-05     weekday  0.14133849    weekday 0.7173230
    ##  6 2015-01-06     weekday  0.12240220    weekday 0.7551956
    ##  7 2015-01-07     weekday  0.12846693    weekday 0.7430661
    ##  8 2015-01-08     weekday  0.29247582    weekday 0.4150484
    ##  9 2015-01-09     weekday  0.03846222    weekday 0.9230756
    ## 10 2015-01-10     weekend  0.89943497    weekend 0.7988699
    ## # ... with 721 more rows

| Variable      | Type        | Description                                       |
|---------------|-------------|---------------------------------------------------|
| `date`        | `Date`      | date of the observation                           |
| `observation` | `character` | indicates if this is a `"weekend"` or `"weekday"` |
| `probability` | `double`    | "model" probability that this is a `"weekend"`    |
| `prediction`  | `character` | "model" prediction of type of day                 |
| `strength`    | `double`    | "model" probability that this is a `"weekend"`    |

Write it out
------------

``` r
devtools::use_data(data_weekend)
```

    ## Saving data_weekend as data_weekend.rda to /Users/ijlyttle/Documents/git/github/public_work/ggoctocal/data
