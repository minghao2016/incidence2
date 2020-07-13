
<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/incidence2)](https://CRAN.R-project.org/package=incidence2)
[![R build
status](https://github.com/reconhub/incidence2/workflows/R-CMD-check/badge.svg)](https://github.com/reconhub/incidence2/actions)
[![codecov](https://codecov.io/gh/reconhub/incidence2/branch/master/graph/badge.svg)](https://codecov.io/gh/reconhub/incidence2)
<!-- badges: end -->

<br> **<span style="color: red;">Disclaimer</span>**

This package is a work in progress. Please reach out to the authors
before using.

# Scope

*incidence2* refocusses the scope of the original
[incidence](https://github.com/reconhub/incidence) package. The aim is
to provide a “tidy” interface for users to work with whilst at the same
time simplifying the underlying implementation. To this end,
*incidence2* concentrates only on the initial data handling, calculation
and graphing of incidence objects. The “fitting” functions of
[incidence](https://github.com/reconhub/incidence)
(e.g. `incidence::fit`) will likely find there place in a smaller,
separate, package with a more consistent interface, more choice of
underlying models, and tidier outputs.

# What does it do?

The main features of the package include:

  - **`incidence()`**: compute incidence from linelist datasets; any
    fixed time interval can be used; the returned object is a tibble
    subclass called *incidence*.

  - plotting functions **`plot()`** and **`facet_plot()`**: these
    functions return customised ggplot2 plots of *incidence* objects
    (see `?plot.incidence` for details).

  - Compatible with [dplyr](https://dplyr.tidyverse.org/) for data
    manipulation. (see `vignette("handling_incidence_objects")` for more
    details).

  - **`regroup()`**: regroup incidence from different groups into one
    global incidence time series.

  - **`cumulate()`**: computes cumulative incidence over time from an
    `incidence` object.

  - **`bootstrap()`**: generates a bootstrapped *incidence()* object by
    re-sampling, with replacement, the original dates of events.

  - **`find_peak()`**: locates the peak time of the epicurve.

  - **`estimate_peak()`**: uses bootstrap to estimate the peak time (and
    related confidence interval) of a partially observed outbreak.

  - **`print()`** and **`summary()`** functions.

  - Conversion functions:
    
      - **`as.data.frame()`**: converts an `incidence()` object into a
        `data.frame`.
    
      - **`as_tibble()`**: convertss an `incidence()` object into a
        `tibble`.

  - Accessor functions: **`get_count_vars()`**, **`get_date_vars()`**,
    **`get_group_vars()`**, **`get_interval()`**, **`get_timespan()`**
    and **`get_n()`**.

# Installing the package

The package is not yet on CRAN but to install the development, *github*
version of the package use:

``` r
devtools::install_github("reconhub/incidence2")
```

Note that this requires the package *devtools* installed.

# Resources

## Vignettes

An short overview of *incidence* is provided below in the worked example
below. More detailed tutorials are distributed as vignettes with the
package:

  - `vignette("Introduction")`
  - `vignette("handling_incidence_objects")`

## Websites

The following websites are available:

  - The *incidence2* project on *github*, useful for developers,
    contributors, and users wanting to post issues, bug reports and
    feature requests: <br> <https://github.com/reconhub/incidence2>

## Getting help online

Bug reports and feature requests should be posted on *github* using the
[*issue* system](https://github.com/reconhub/incidence/issues). All
other questions should be posted on the **RECON** slack channel see
<https://www.repidemicsconsortium.org/forum/> for details on how to
join.

# A quick overview

This short example uses the simulated Ebola Virus Disease (EVD) outbreak
from the package [*outbreaks*](https://github.com/reconhub/outbreaks).
It shows how to compute incidence for various time steps plot the
resulting incidence tables.

First, we load the data:

``` r
library(outbreaks)
library(incidence2)

dat <- ebola_sim_clean$linelist
str(dat)
#> 'data.frame':    5829 obs. of  11 variables:
#>  $ case_id                : chr  "d1fafd" "53371b" "f5c3d8" "6c286a" ...
#>  $ generation             : int  0 1 1 2 2 0 3 3 2 3 ...
#>  $ date_of_infection      : Date, format: NA "2014-04-09" ...
#>  $ date_of_onset          : Date, format: "2014-04-07" "2014-04-15" ...
#>  $ date_of_hospitalisation: Date, format: "2014-04-17" "2014-04-20" ...
#>  $ date_of_outcome        : Date, format: "2014-04-19" NA ...
#>  $ outcome                : Factor w/ 2 levels "Death","Recover": NA NA 2 1 2 NA 2 1 2 1 ...
#>  $ gender                 : Factor w/ 2 levels "f","m": 1 2 1 1 1 1 1 1 2 2 ...
#>  $ hospital               : Factor w/ 5 levels "Connaught Hospital",..: 2 1 3 NA 3 NA 1 4 3 5 ...
#>  $ lon                    : num  -13.2 -13.2 -13.2 -13.2 -13.2 ...
#>  $ lat                    : num  8.47 8.46 8.48 8.46 8.45 ...
```

## Computing and plotting incidence

We compute the weekly incidence:

``` r
i_7 <- incidence(dat, date_index = date_of_onset, interval = 7)
i_7
#> <incidence object>
#> [5829 cases from days 2014-04-07 to 2015-04-27]
#> [interval: 7 days]
#> [cumulative: FALSE]
#> 
#>    bin_date   date_group count
#>    <date>     <aweek>    <int>
#>  1 2014-04-07 2014-W15       1
#>  2 2014-04-14 2014-W16       1
#>  3 2014-04-21 2014-W17       5
#>  4 2014-04-28 2014-W18       4
#>  5 2014-05-05 2014-W19      12
#>  6 2014-05-12 2014-W20      17
#>  7 2014-05-19 2014-W21      15
#>  8 2014-05-26 2014-W22      19
#>  9 2014-06-02 2014-W23      23
#> 10 2014-06-09 2014-W24      21
#> # … with 46 more rows
summary(i_7)
#> <incidence object>
#> 
#> 5829 cases from days 2014-04-07 to 2015-04-27
#> interval: 7 days
#> cumulative: FALSE
#> timespan: 386 days
plot(i_7, color = "black")
```

<img src="man/figures/README-incid7-1.png" width="100%" />

`incidence()` can also compute incidence by specified groups using the
`groups` argument. For instance, we can compute the weekly incidence by
gender and plot in a single, stacked chart:

``` r
i_7_sex <- incidence(dat, interval = "week", 
                     date_index = date_of_onset, groups = gender)
i_7_sex
#> <incidence object>
#> [5829 cases from days 2014-04-07 to 2015-04-27]
#> [interval: 1 week]
#> [cumulative: FALSE]
#> 
#>    bin_date   date_group gender count
#>    <date>     <aweek>    <fct>  <int>
#>  1 2014-04-07 2014-W15   f          1
#>  2 2014-04-07 2014-W15   m          0
#>  3 2014-04-14 2014-W16   f          0
#>  4 2014-04-14 2014-W16   m          1
#>  5 2014-04-21 2014-W17   f          5
#>  6 2014-04-21 2014-W17   m          0
#>  7 2014-04-28 2014-W18   f          2
#>  8 2014-04-28 2014-W18   m          2
#>  9 2014-05-05 2014-W19   f          9
#> 10 2014-05-05 2014-W19   m          3
#> # … with 102 more rows
summary(i_7_sex)
#> <incidence object>
#> 
#> 5829 cases from days 2014-04-07 to 2015-04-27
#> interval: 1 week
#> cumulative: FALSE
#> timespan: 386 days
#> 
#> 1 grouped variable
#> 
#>   gender count
#>   <fct>  <int>
#> 1 f       2934
#> 2 m       2895
plot(i_7_sex, fill = "gender", color = "black")
```

<img src="man/figures/README-genderstack-1.png" width="100%" />

we can facet our plot (grouping detected automatically):

``` r
facet_plot(i_7_sex, n_breaks = 4)
```

<img src="man/figures/README-genderfacet-1.png" width="100%" />

and we can also group by multiple variables specifying different facets
and fills:

``` r
# incidence is compatible with the magrittr pipe operator
i_7_sh <- 
  dat %>% 
  incidence(date_index = date_of_onset, interval = "week", 
            groups = c(gender, hospital))
i_7_sh
#> <incidence object>
#> [5829 cases from days 2014-04-07 to 2015-04-27]
#> [interval: 1 week]
#> [cumulative: FALSE]
#> 
#>    bin_date   date_group gender hospital                                   count
#>    <date>     <aweek>    <fct>  <fct>                                      <int>
#>  1 2014-04-07 2014-W15   f      Military Hospital                              1
#>  2 2014-04-07 2014-W15   m      Military Hospital                              0
#>  3 2014-04-07 2014-W15   f      Connaught Hospital                             0
#>  4 2014-04-07 2014-W15   m      Connaught Hospital                             0
#>  5 2014-04-07 2014-W15   f      other                                          0
#>  6 2014-04-07 2014-W15   m      other                                          0
#>  7 2014-04-07 2014-W15   f      <NA>                                           0
#>  8 2014-04-07 2014-W15   m      <NA>                                           0
#>  9 2014-04-07 2014-W15   f      Princess Christian Maternity Hospital (PC…     0
#> 10 2014-04-07 2014-W15   m      Princess Christian Maternity Hospital (PC…     0
#> # … with 662 more rows
i_7_sh %>% summary()
#> <incidence object>
#> 
#> 5829 cases from days 2014-04-07 to 2015-04-27
#> interval: 1 week
#> cumulative: FALSE
#> timespan: 386 days
#> 
#> 2 grouped variables
#> 
#>   gender count
#>   <fct>  <int>
#> 1 f       2934
#> 2 m       2895
#> 
#> 
#>   hospital                                     count
#>   <fct>                                        <int>
#> 1 Connaught Hospital                            1737
#> 2 Military Hospital                              889
#> 3 other                                          876
#> 4 Princess Christian Maternity Hospital (PCMH)   420
#> 5 Rokupa Hospital                                451
#> 6 <NA>                                          1456
i_7_sh %>% facet_plot(facets = gender, fill = hospital)
```

<img src="man/figures/README-genderhospital-1.png" width="100%" />