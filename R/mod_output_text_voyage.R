#' output_text_voyage UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS
#' @importFrom glue glue
outputVoyageTextUI <- function(id){
    div(class = "ui raised segment",
        div(a(class="ui green ribbon label", "Voyage Details"),
            h5("Details of longest most recent voyage by the selected vessel"),
            textOutput(NS(id,"vessel_text")),
            textOutput(NS(id,"vessel_type_text")),
            textOutput(NS(id,"vessel_distance_text")),
            textOutput(NS(id,"vessel_from_text")),
            textOutput(NS(id,"vessel_to_text")),
        )
    )
}

#' output_text_voyage Server Functions
#'
#' @noRd
outputVoyageTextServer <- function(id, voyage){
    moduleServer(id, function(input, output, session) {
        output$vessel_text <- renderText({
            glue("Vessel: {voyage()$SHIPNAME}(id:{voyage()$SHIP_ID})")
        })
        output$vessel_type_text <- renderText({
            glue("Type: {voyage()$ship_type}")
        })
        output$vessel_distance_text <- renderText({
            glue("Distance Sailed: {round(voyage()$distance_covered,2)} meters")
        })
        output$vessel_from_text <- renderText({
            glue("From: ({voyage()$lag_LAT},{voyage()$lag_LON})")
        })
        output$vessel_to_text <- renderText({
            glue("To: ({voyage()$LAT},{voyage()$LON})")
        })

    })
}

