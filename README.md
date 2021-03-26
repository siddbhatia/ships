ships
================

The goal of `ships` is to visualize most recent route of a vessel on a
map.

## For users

### Install

To install from github

``` r
remotes::install_github('siddbhatia/ships')
```

To install locally

``` bash
git clone git@github.com:siddbhatia/ships.git
R -e "remotes::install_local('ships')"
```

### Run the application

``` r
ships::run_app(data = readRDS(ships::app_sys("extdata/longest_most_recent.rds")))
```

### For developers

#### Restore renv

``` r
renv::install()
pkgload::load_all()
```

#### Make changes and new installs

#### Document package

``` r
roxygen2::roxygenise(package.dir = ".")
```

#### Test package

``` r
devtools::test(package.dir = ".")
```

#### Check before commit

``` r
devtools::check()
```
