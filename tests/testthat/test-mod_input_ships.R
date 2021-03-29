
inputShipServer <- function(id){
    data = readRDS(app_sys("extdata/longest_most_recent.rds"))
    moduleServer( id, function(input, output, session){
        observeEvent(input$vessel_type_dd,{
            if (!is.null(input$vessel_type_dd)){
                updateSelectInput(session,"vessel_name_dd",
                                  choices = data %>%
                                      filter(ship_type==input$vessel_type_dd)%>%
                                      pull("SHIPNAME"),
                                  selected = NULL)
            }
        })
        list(
            points = eventReactive(input$update, {
                rbind(
                    data %>%
                        filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                        mutate(lng=LON, lat=LAT, popup="Destination",
                               icons = "red"
                        ) %>%
                        select(c(lng, lat, popup, icons)),
                    data %>%
                        filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                        mutate(lng=lag_LON, lat=lag_LAT, popup="Source",
                               icons = "green") %>%
                        select(c(lng, lat,popup, icons))
                )
            }, ignoreNULL = FALSE),
            voyage = eventReactive(input$update, {
                data %>%
                    filter(ship_type==input$vessel_type_dd && SHIPNAME==input$vessel_name_dd) %>%
                    select(ship_type, SHIPNAME, SHIP_ID, distance_covered, LAT, LON, lag_LAT, lag_LON)
            }, ignoreNULL = FALSE)
        )
    })
}

test_that("inputs return points and voyage", {
    testServer(inputShipServer, {
        c(points,voyage) %<-% session$getReturned()
        session$setInputs(vessel_type_dd = "Fishing",
                          vessel_name_dd="KRISTIN"
                          )
        expect_equal(voyage()$LAT, 57.60241)
        expect_equal(voyage()$LON, 11.81972)

    })
})
