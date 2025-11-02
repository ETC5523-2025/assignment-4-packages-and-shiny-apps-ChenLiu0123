#' Monthly Summary of Yarra River Streamflow
  #'
  #' Monthly aggregated streamflow statistics for the Yarra River.
  #'
  #' @format A data frame with `r nrow(monthly_summary)` rows and 8 variables:
  #' \describe{
  #'   \item{year}{Year}
  #'   \item{month}{Month as ordered factor}
  #'   \item{season}{Season}
  #'   \item{avg_flow}{Average daily flow for the month}
  #'   \item{max_flow}{Maximum daily flow for the month}
  #'   \item{min_flow}{Minimum daily flow for the month}
  #'   \item{total_flow}{Total flow for the month}
  #'   \item{n_days}{Number of days with data}
  #' }
  #' @source Derived from daily Yarra River streamflow data
  "monthly_summary"
  #' @name monthly_summary
  #' @docType data
  #' @keywords datasets
  
