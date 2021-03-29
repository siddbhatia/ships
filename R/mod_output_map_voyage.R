#' output_map_voyage UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#' @importFrom leaflet leafletOutput renderLeaflet leaflet addMarkers addProviderTiles addAwesomeMarkers makeAwesomeIcon
#' @importFrom shiny NS
outputVoyageMapUI <- function(id){
    leafletOutput(NS(id,"main_data"),  height = "500")
}

#' output_map_voyage Server Functions
#'
#' @noRd
outputVoyageMapServer <- function(id, points){
    moduleServer(id, function(input, output, session) {
        output$main_data <- renderLeaflet({
            leaflet(points()) %>%
                addProviderTiles("CartoDB.Positron") %>%
                addAwesomeMarkers(lng = ~ lng, lat = ~ lat,popup= ~ popup, icon = makeAwesomeIcon(
                    icon = "ship",
                    markerColor = ~icons,
                    library = "fa"
                ))

        })
    })
}

