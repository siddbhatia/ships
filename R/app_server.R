#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom zeallot %<-%
#' @noRd
app_server <- function(input, output, session ) {
    c(points,voyage) %<-% inputShipServer("Vessels")
    outputVoyageTextServer('TextVoyage',voyage)
    outputVoyageMapServer('MapVoyage',points)
}
