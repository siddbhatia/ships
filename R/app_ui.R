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
            grid(
                grid_template(default = list(
                    areas = rbind(
                        c("menu")
                    ),
                    rows_height = c("100%"),
                    cols_width = c("auto")
                )),
                menu = div(
                    grid(
                        grid_template(
                            default = list(
                                areas = rbind(
                                    c("map_area"),
                                    c("text_inputs_area")
                                ),
                                rows_height = c("85%","15%"),
                                cols_width = c("auto")
                            )
                        ),
                        map_area = outputVoyageMapUI('MapVoyage'),
                        text_inputs_area = grid(
                            grid_template(default = list(
                                areas = cbind(
                                    c("voyage_details"),
                                    c("inputs")
                                ),
                                rows_height = c("auto"),
                                cols_width = c("50%","50%")
                            )),
                            voyage_details = outputVoyageTextUI('TextVoyage'),
                            inputs = inputShipUI("Vessels")
                        )
                    )
                )
            )
        )
    )
}
