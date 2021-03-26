#' io_module UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny.semantic grid grid_template action_button accordion
#' @importFrom dplyr filter select %>%
#' @importFrom shiny NS
#' @importFrom leaflet leafletOutput renderLeaflet leaflet addMarkers addTiles
#' @importFrom glue glue
io_module_ui <- function(id){
    ns <- NS(id)
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
                                           selectInput(NS(id,"vessel_type_dd"),
                                                       label ="Vessel Type",
                                                       choices=get_ships_options("data")["ship_type"],
                                                       multiple = F,
                                                       selected = "Fishing",
                                                       selectize = T)
                         ),
                         vessel_name = div(style="text-align:left;padding:10px",
                                           selectInput(NS(id,"vessel_name_dd"),
                                                       label ="Vessel Name",
                                                       choices=get_ships_options("data")["SHIPNAME"],
                                                       multiple = F,
                                                       selected = "KRISTIN",
                                                       selectize = T)),
                         update = div(style="text-align:center;padding:10px",
                                      br(),
                                      action_button(NS(id,"update"), "Update")
                         )
                     )
        ),
        menu = div(style="text-align:center;",
            grid(
                grid_template(
                    default = list(
                        areas = rbind(
                            c("map_area"),
                            c("text_area")
                            ),
                    rows_height = c("70%","30%"),
                    cols_width = c("auto")
                )
                ),
                map_area = leafletOutput(NS(id,"main_data"),),
                text_area = div(class = "ui raised segment",
                                textOutput(NS(id,"main_text"))
                )

            )
        )
    )
}

#' io_module Server Functions
#'
#' @noRd
io_module_server <- function(id){

    moduleServer( id, function(input, output, session){
        observe({
            if (!is.null(input$vessel_type_dd)){
                updateSelectInput(session,
                                  "vessel_name_dd",
                                  choices=get_ships_options("data")[(get_ships_options("data")["ship_type"] == input$vessel_type_dd), "SHIPNAME"],
                                  selected = NULL)
            }

        })

        points <- eventReactive(input$update, {
            rbind(
            get_ships_options("data") %>%
                filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                mutate(lng=LON, lat=LAT, popup="Destination") %>%
                select(c(lng, lat, popup)),
            get_ships_options("data") %>%
                filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                mutate(lng=lag_LON, lat=lag_LAT, popup="Source") %>%
                select(c(lng, lat,popup))
            )
        }, ignoreNULL = FALSE)

        text_note <- eventReactive(input$update, {
            voyage <- get_ships_options("data") %>%
                filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                select(ship_type, SHIPNAME, SHIP_ID, distance_covered, LAT, LON, lag_LAT, lag_LON)
            glue("Vessel: {voyage$SHIPNAME}(id:{voyage$SHIP_ID}) sailed a distance of {voyage$distance_covered} meters from ({voyage$lag_LAT},{voyage$lag_LON}) to ({voyage$LAT},{voyage$LON}).")

        }, ignoreNULL = FALSE)


        output$main_data <- renderLeaflet({
            leaflet(points()) %>%
                addTiles() %>%
                addMarkers(lng = ~ lng, lat = ~ lat,popup= ~ popup)

        })

        output$main_text <- renderText({
            text_note()
        })

    })
}
