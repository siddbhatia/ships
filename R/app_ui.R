#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom htmltools tags
#' @importFrom shiny.semantic semanticPage grid grid_template action_button
#' @noRd
app_ui <- function(request) {
    htmltools::tagList(
        semanticPage(
            tags$head(tags$style(type = "text/css",paste0(".selectize-dropdown {bottom: 100% !important; top:auto!important; }}"))),
            title = "Ships",
            grid(
                grid_template(default = list(
                    areas = rbind(
                        c("menu"),
                        c("header")
                        ),
                rows_height = c("90%", "10%"),
                cols_width = c("auto")
                )),
                 header = div(style="text-align:center;",
                     grid(
                         grid_template(
                                      default = list(
                                          areas = cbind(
                                              c("vessel_type"),
                                              c("vessel_name"),
                                              c("update")

                                          ),
                                          rows_height = c("auto"),
                                          cols_width = c("33%","33%","33%")
                                      )
                                  ),
                                  vessel_type = div(style="text-align:left; padding:10px",
                                                    selectInput("simple_dropdown",
                                                                label ="Vessel Type",
                                                                choices=LETTERS,
                                                                multiple = F,
                                                                selected = "A",
                                                                selectize = T)
                                                    ),
                                  vessel_name = div(style="text-align:left;padding:10px",
                                                    selectInput("simple_dropdown",
                                                                label ="Vessel Name",
                                                                choices=LETTERS,
                                                                multiple = F,
                                                                selected = "A",
                                                                selectize = T)),
                                  update = div(style="text-align:center;padding:10px",
                                               br(),
                                               action_button("update", "Update")
                                  )
                              )
                              ),
                 menu = div("Main Area")
                )
        )
    )

}
