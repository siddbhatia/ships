#' Access files in the current app
#'
#' @param ... Character vector specifying directory and or file to
#'     point to inside the current package.
#'
#' @noRd
app_sys <- function(...){
    system.file(..., package = "ships")
}


#' Get all or one ships options
#'
#' This function is to be used inside the
#' server and UI from your app, in order to call the
#' parameters passed to \code{run_app()}.
#'
#' @param which NULL (default), or the name of an option
#' @importFrom shiny getShinyOption
#' @export
get_ships_options <- function(which = NULL){

    if (is.null(which)){
        getShinyOption("runtime_options")
    } else {
        if (length(which)>1){
            unlist(getShinyOption("runtime_options")[which])
        }
        else{
            getShinyOption("runtime_options")[[which]]
        }
    }
}
