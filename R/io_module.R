#' io_module UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny.semantic grid grid_template action_button accordion
#' @importFrom dplyr filter select %>% mutate
#' @importFrom shiny NS
#' @importFrom leaflet leafletOutput renderLeaflet leaflet addMarkers addProviderTiles addAwesomeMarkers makeAwesomeIcon
#' @importFrom glue glue
io_module_ui <- function(id){
    ns <- NS(id)
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
                map_area = leafletOutput(NS(id,"main_data"),  height = "670"),
                text_inputs_area =
                    grid(
                        grid_template(default = list(
                            areas = cbind(
                                c("voyage_details"),
                                c("inputs")
                            ),
                            rows_height = c("auto"),
                            cols_width = c("50%","50%")
                        )),
                        voyage_details = div(class = "ui raised segment",
                                             div(a(class="ui green ribbon label", "Voyage Details"),
                                                 h4("Details of longest most recent voyage by the selected vessel"),
                                                 textOutput(NS(id,"vessel_text")),
                                                 textOutput(NS(id,"vessel_type_text")),
                                                 textOutput(NS(id,"vessel_distance_text")),
                                                 textOutput(NS(id,"vessel_from_text")),
                                                 textOutput(NS(id,"vessel_to_text")),
                                             )
                                             ),
                        inputs = div(class = "ui raised segment",
                                     div(a(class="ui blue ribbon label", "Inputs"),
                                         grid(
                                             grid_template(
                                                 default = list(
                                                     areas = cbind(
                                                         c("vessel_type"),
                                                         c("vessel_name"),
                                                         c("update")

                                                     ),
                                                     rows_height = c("40%","40%","20%"),
                                                     cols_width = c("auto")
                                                 )
                                             ),
                                             vessel_type = div(style="text-align:left;padding:0px",
                                                               selectInput(NS(id,"vessel_type_dd"),
                                                                           label ="Vessel Type",
                                                                           choices=get_ships_options("data")["ship_type"],
                                                                           multiple = F,
                                                                           selectize = T,
                                                                           width = "200")
                                             ),
                                             vessel_name = div(style="text-align:left;padding:0px",
                                                               selectInput(NS(id,"vessel_name_dd"),
                                                                           label ="Vessel Name",
                                                                           choices=get_ships_options("data")["SHIPNAME"],
                                                                           multiple = F,
                                                                           selectize = T,
                                                                           width = "200")),
                                             update = div(style="text-align:center;padding:1px",
                                                          br(),
                                                          action_button(NS(id,"update"), "Update",width = "100")
                                             )
                                         )

                                     )

                        )
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
        }, ignoreNULL = FALSE)

        voyage <- eventReactive(input$update, {
            get_ships_options("data") %>%
                filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                select(ship_type, SHIPNAME, SHIP_ID, distance_covered, LAT, LON, lag_LAT, lag_LON)
        }, ignoreNULL = FALSE)


        output$main_data <- renderLeaflet({
            leaflet(points()) %>%
                addProviderTiles("CartoDB.Positron") %>%
                addAwesomeMarkers(lng = ~ lng, lat = ~ lat,popup= ~ popup, icon = makeAwesomeIcon(
                    icon = "ship",
                    markerColor = ~icons,
                    library = "fa"
                ))

        })
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
