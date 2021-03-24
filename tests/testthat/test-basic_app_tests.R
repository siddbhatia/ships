## test that ui is a taglist
test_that("app ui", {
    ui <- app_ui()
    act <- quasi_label(rlang::enquo(ui), arg = "object")
    act$class <- class(ui)
    expect(
        "shiny.tag.list" %in% act$class,
        sprintf("%s has class %s, not class 'shiny.tag.list'.", act$lab, paste(act$class, collapse = ", "))
    )
    invisible(act$val)

})

test_that("app server", {
    server <- app_server
    expect_type(server, "closure")
})

# Configure this test to fit your need
test_that(
    "app launches",{
        x <- processx::process$new(
            "R",
            c(
                "-e",
                "pkgload::load_all(here::here());run_app()"
            )
        )
        expect_true(x$is_alive())
        x$kill()
    }
)





