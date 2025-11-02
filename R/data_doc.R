#' Yarra River Streamflow Data
  #'
  #' Daily streamflow data for the Yarra River at McMahons site.
  #' Contains daily mean flow measurements from 1962 onwards.
  #'
  #' @format A data frame with `r nrow(yarra_water_data)` rows and 17 variables:
  #' \describe{
  #'   \item{site_id}{Monitoring site identifier (229108)}
  #'   \item{site_name}{Site name: YARRA DS MCMAHONS}
  #'   \item{datetime}{Date and time of measurement}
  #'   \item{date}{Date of measurement}
  #'   \item{data_type}{Type of data: Quantity}
  #'   \item{parameter_id}{Parameter identifier: 141.5}
  #'   \item{parameter}{Parameter name: Streamflow (mean daily)}
  #'   \item{value}{Streamflow value in ML/day}
  #'   \item{unit}{Unit of measurement: ML/day}
  #'   \item{quality}{Data quality flag}
  #'   \item{resolution}{Data resolution: Raw Data}
  #'   \item{year}{Year of measurement}
  #'   \item{month}{Month of measurement}
  #'   \item{day}{Day of measurement}
  #'   \item{season}{Season: Summer, Autumn, Winter, Spring}
  #'   \item{flow_category}{Flow category: Low, Medium, High, Very High}
  #'   \item{log_flow}{Logarithm of flow value}
  #'   \item{flow_7day_avg}{7-day moving average of flow}
  #' }
  #' @source Water monitoring data
  "yarra_water_data"
  #' @name yarra_water_data
  #' @docType data
  #' @keywords datasets
  
