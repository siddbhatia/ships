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
run_app()
```

### For developers

#### Restore renv

``` r
renv::restore()
```

#### Make changes and new installs

#### Update renv for dependencies

``` r
renv::snapshot()
```

#### Document package

``` r
roxygen2::roxygenise(package.dir = ".")
```

#### Check before commit

``` r
devtools::check()
```

#### Build documentation and vignettes

``` r
pkgdown::build_site()
```
