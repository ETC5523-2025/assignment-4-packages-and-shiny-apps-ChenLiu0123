#' Launch Yarra River Streamflow Explorer
#'
#' Launches the interactive Shiny application for exploring Yarra River
#' streamflow data. The app allows users to visualize flow patterns,
#' analyze seasonal variations, and identify high flow events.
#'
#' @return No return value, called for side effects
#' @export
#' @examples
#' \dontrun{
#' # Launch the Shiny app
#' launch_app()
#' }
launch_app <- function() {
  appDir <- system.file("shiny-apps", "yarra-explorer", package = "YarraWaterAnalysis")
  
  if (appDir == "") {
    stop("Could not find application directory. Try re-installing the package.", 
         call. = FALSE)
  }
  
  shiny::runApp(appDir, display.mode = "normal")
}
