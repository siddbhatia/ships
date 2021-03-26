#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom htmltools tags
#' @importFrom shiny.semantic semanticPage
#' @noRd
app_ui <- function(request) {
    htmltools::tagList(
        semanticPage(
            tags$head(tags$style(type = "text/css",paste0(".selectize-dropdown {bottom: 100% !important; top:auto!important; }}"))),
            title = "Ships",
            io_module_ui("io")

        )
    )

}
