#' inputs_ships UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny.semantic grid grid_template action_button accordion
#' @importFrom dplyr filter select %>% mutate pull
#' @importFrom shiny NS
inputShipUI <- function(id){
    div(class = "ui raised segment",
        div(a(class="ui blue ribbon label", "Inputs"),
            div(
            style="text-align:center;",
            h5("Please select vessel details and press Update"),
            grid(
                grid_template(
                    default = list(
                        areas = cbind(
                            c("vessel_type"),
                            c("vessel_name"),
                            c("update")),
                        rows_height = c( "auto"),
                        cols_width = c("33%","33%", "33%")
                    )
                ),
                vessel_type = div(style="text-align:left;padding:1px",
                                  selectInput(NS(id,"vessel_type_dd"),
                                              label ="Vessel Type",
                                              choices=get_ships_options("data")["ship_type"],
                                              selectize = T,
                                              selected = "Fishing",
                                              width = "300")
                ),
                vessel_name = div(style="text-align:left;padding:1px",
                                  selectInput(NS(id,"vessel_name_dd"),
                                              label ="Vessel Name",
                                              choices=NULL,
                                              multiple = F,
                                              selectize = T,
                                              selected = "KRISTIN",
                                              width = "300")),
            update = div(style="text-align:center;padding:0px",
                         br(),
                         action_button(NS(id,"update"), "Update",width = "100")
                         )
            )
            ),
            br(),
            br(),
            br()
        )
    )
}

#' inputs_ships Server Functions
#'
#' @noRd
inputShipServer <- function(id){

    moduleServer( id, function(input, output, session){
        observeEvent(input$vessel_type_dd,{
            if (!is.null(input$vessel_type_dd)){
                updateSelectInput(session,"vessel_name_dd",
                                  choices = get_ships_options("data")%>%
                                      filter(ship_type==input$vessel_type_dd)%>%
                                      pull("SHIPNAME"),
                                  selected = NULL)
            }
        })
        list(
            points = eventReactive(input$update, {
                rbind(
                    get_ships_options("data") %>%
                        filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                        mutate(lng=LON, lat=LAT, popup="Destination",
                               icons = "red"
                        ) %>%
                        select(c(lng, lat, popup, icons)),
                    get_ships_options("data") %>%
                        filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                        mutate(lng=lag_LON, lat=lag_LAT, popup="Source",
                               icons = "green") %>%
                        select(c(lng, lat,popup, icons))
                )
            }, ignoreNULL = FALSE),
            voyage = eventReactive(input$update, {
                get_ships_options("data") %>%
                    filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                    select(ship_type, SHIPNAME, SHIP_ID, distance_covered, LAT, LON, lag_LAT, lag_LON)
            }, ignoreNULL = FALSE)
        )
    })
}

