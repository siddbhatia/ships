require(shiny)
require(pkgload)
pkgload::load_all()
ships::run_app(
    data = readRDS(app_sys("extdata/longest_most_recent.rds"))
)
