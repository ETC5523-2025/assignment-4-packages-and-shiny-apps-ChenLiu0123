library(dplyr)
library(readxl)
library(lubridate)
library(tidyr)
#' Calculate Flow Statistics
#'
#' Calculate basic statistics for Yarra River streamflow data.
#'
#' @param data A data frame containing Yarra River flow data
#' @return A data frame with summary statistics
#' @export
#' @examples
#' data(yarra_water_data)
#' calculate_flow_stats(yarra_water_data)
calculate_flow_stats <- function(data) {
  `%>%` <- magrittr::`%>%`

  calculate_flow_stats <- function(data) {
    data %>%
      dplyr::summarise(
        n_observations = dplyr::n(),
        avg_flow = base::mean(value, na.rm = TRUE),
        median_flow = stats::median(value, na.rm = TRUE),
        max_flow = base::max(value, na.rm = TRUE),
        min_flow = base::min(value, na.rm = TRUE),
        sd_flow = stats::sd(value, na.rm = TRUE),
        cv_flow = stats::sd(value, na.rm = TRUE) / base::mean(value, na.rm = TRUE),  # Coefficient of variation
        total_period_days = as.numeric(base::difftime(base::max(date), base::min(date), units = "days")),
        data_coverage = dplyr::n() / as.numeric(base::difftime(base::max(date), base::min(date), units = "days"))
      )
  }

}

#' Filter Data by Date Range
#' Filter Yarra River data by date range.
#' @param data Yarra River data frame
#' @param start_date Start date (YYYY-MM-DD)
#' @param end_date End date (YYYY-MM-DD)
#' @return Filtered data frame
#' @export
filter_by_date <- function(data, start_date, end_date) {
  `%>%` <- magrittr::`%>%`


  start_date <- base::as.Date(start_date)
  end_date <- base::as.Date(end_date)

  data %>%
    dplyr::filter(date >= start_date & date <= end_date)

}

#' Analyze Seasonal Patterns
#'
#' Calculate seasonal flow patterns.
#'
#' @param data Yarra River data frame
#' @return Seasonal summary statistics
#' @export
analyze_seasonal_patterns <- function(data) {
  `%>%` <- magrittr::`%>%`


  data %>%
    dplyr::group_by(season) %>%
    dplyr::summarise(
      avg_flow = base::mean(value, na.rm = TRUE),
      median_flow = stats::median(value, na.rm = TRUE),
      max_flow = base::max(value, na.rm = TRUE),
      min_flow = base::min(value, na.rm = TRUE),
      n_observations = dplyr::n(),
      .groups = 'drop'
    ) %>%
    dplyr::arrange(avg_flow)



}






#' Detect High Flow Events
#' Identify high flow events based on threshold.
#' @param data Yarra River data frame
#' @param threshold Flow threshold for high events (ML/day)
#' @return Data frame with high flow events
#' @export
detect_high_flow_events <- function(data, threshold = 200) {
  `%>%` <- magrittr::`%>%`

  data %>%
    dplyr::filter(value >= threshold) %>%
    dplyr::arrange(desc(value))
}


#' Calculate Flow Duration Curve
#' Generate flow duration curve data.
#' @param data Yarra River data frame
#' @return Flow duration curve data
#' @export
calculate_flow_duration <- function(data) {
  `%>%` <- magrittr::`%>%`


  data %>%
    dplyr::arrange(desc(value)) %>%
    dplyr::mutate(
      rank = dplyr::row_number(),
      exceedance_prob = rank / (dplyr::n() + 1) * 100
    ) %>%
    dplyr::select(value, exceedance_prob, rank)
}
