#' Run the Shiny Application
#'
#' @param ... A series of options to be used inside the app
#' using `shinyOptions('runtime_options')[[<option>]]`
#'
#' @export
#' @importFrom shiny shinyApp
run_app <- function(
    ...
) {
    app <- shinyApp(
        ui = app_ui,
        server = app_server
    )

    app$appOptions$runtime_options <- list(...)
    app
}
