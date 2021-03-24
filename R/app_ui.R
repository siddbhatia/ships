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
            title = "My page",
            div(class = "ui button", icon("user"),  "Hello World")
        )
    )

}
