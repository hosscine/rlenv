
#' Preprocess before running shiny app
#'
#' @export
startEnvironment <- function() {
  if(!exists("env")){
    env <- rlenv::volcanoExplorer$new()
    assign("env",env,envir = globalenv())
  }

  appDir <- system.file("shiny-rl-environment", package = "rlenv")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `rlenv`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
