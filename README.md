ships
================

The goal of `ships` is to visualize most recent route of a vessel on a
map.

## For users

### Install

To install from github

``` r
remotes::install_github('siddbhatia/ships', build_vignettes=TRUE)
```

To install locally

``` bash
git clone git@github.com:siddbhatia/ships.git
R -e "remotes::install_local('ships', build_vignettes=TRUE)"
```

Refer to logic for pre-processing raw data in the vignettes.

### Run the application

``` r
ships::run_app(data = readRDS(system.file("extdata","longest_most_recent.rds", package = "ships")))
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
