# Prepare Yarra River Water Quality Data
# This script cleans and prepares the Yarra River streamflow data
# for analysis and the Shiny application.

library(dplyr)
library(readxl)
library(lubridate)
library(tidyr)

# read the data
yarra_raw <- readxl::read_excel("data-raw/yarra_wq.xls", sheet = "yarra_wq")

# Clean and process Yarra River streamflow data

clean_yarra_data <- function(raw_data) {
  cleaned_data <- raw_data %>%
    rename(
      site_id = `Site ID`,
      site_name = Name,
      datetime = Datetime,
      data_type = `Data Type`,
      parameter_id = `Parameter ID`,
      parameter = Parameter,
      value = Value,
      unit = `Unit of Measurement`,
      quality = Quality,
      resolution = Resolution
    ) %>%
    drop_na(datetime) %>%
    mutate(
        date = as.Date(datetime),
      year = year(date),
      month = month(date, label = TRUE),
      day = day(date),
      season = case_when(
        month %in% c('12月', '1月', '2月') ~ "Summer",
        month %in% c('3月', '4月', '5月') ~ "Autumn",
        month %in% c('6月', '7月', '8月') ~ "Winter",
        month %in% c('9月', '10月', '11月') ~ "Spring"
      ),
      flow_category = case_when(
        value < 100 ~ "Low",
        value < 200 ~ "Medium",
        value < 300 ~ "High",
        TRUE ~ "Very High"
      )
    ) %>%
    arrange(date) %>%
    mutate(
      log_flow = log10(value + 1),
      flow_7day_avg = zoo::rollmean(value, 7, fill = NA, align = "right")
    )

  return(cleaned_data)
}

# apply the cleaning function
yarra_water_data <- clean_yarra_data(yarra_raw)

# save the data
usethis::use_data(yarra_water_data, overwrite = TRUE)

# create monthly summary data
monthly_summary <- yarra_water_data %>%
  group_by(year, month, season) %>%
  summarise(
    avg_flow = mean(value, na.rm = TRUE),
    max_flow = max(value, na.rm = TRUE),
    min_flow = min(value, na.rm = TRUE),
    total_flow = sum(value, na.rm = TRUE),
    n_days = n(),
    .groups = 'drop'
  )

usethis::use_data(monthly_summary, overwrite = TRUE)

# Create a data document
writeLines(
  "#' Yarra River Streamflow Data
  #'
  #' Daily streamflow data for the Yarra River at McMahons site.
  #' Contains daily mean flow measurements from 1962 onwards.
  #'
  #' @format A data frame with `r nrow(yarra_water_data)` rows and 17 variables:
  #' \\describe{
  #'   \\item{site_id}{Monitoring site identifier (229108)}
  #'   \\item{site_name}{Site name: YARRA DS MCMAHONS}
  #'   \\item{datetime}{Date and time of measurement}
  #'   \\item{date}{Date of measurement}
  #'   \\item{data_type}{Type of data: Quantity}
  #'   \\item{parameter_id}{Parameter identifier: 141.5}
  #'   \\item{parameter}{Parameter name: Streamflow (mean daily)}
  #'   \\item{value}{Streamflow value in ML/day}
  #'   \\item{unit}{Unit of measurement: ML/day}
  #'   \\item{quality}{Data quality flag}
  #'   \\item{resolution}{Data resolution: Raw Data}
  #'   \\item{year}{Year of measurement}
  #'   \\item{month}{Month of measurement}
  #'   \\item{day}{Day of measurement}
  #'   \\item{season}{Season: Summer, Autumn, Winter, Spring}
  #'   \\item{flow_category}{Flow category: Low, Medium, High, Very High}
  #'   \\item{log_flow}{Logarithm of flow value}
  #'   \\item{flow_7day_avg}{7-day moving average of flow}
  #' }
  #' @source Water monitoring data
  \"yarra_water_data\"
  #' @name yarra_water_data
  #' @docType data
  #' @keywords datasets
  ",
  "R/data_doc.R"
)

writeLines(
  "#' Monthly Summary of Yarra River Streamflow
  #'
  #' Monthly aggregated streamflow statistics for the Yarra River.
  #'
  #' @format A data frame with `r nrow(monthly_summary)` rows and 8 variables:
  #' \\describe{
  #'   \\item{year}{Year}
  #'   \\item{month}{Month as ordered factor}
  #'   \\item{season}{Season}
  #'   \\item{avg_flow}{Average daily flow for the month}
  #'   \\item{max_flow}{Maximum daily flow for the month}
  #'   \\item{min_flow}{Minimum daily flow for the month}
  #'   \\item{total_flow}{Total flow for the month}
  #'   \\item{n_days}{Number of days with data}
  #' }
  #' @source Derived from daily Yarra River streamflow data
  \"monthly_summary\"
  #' @name monthly_summary
  #' @docType data
  #' @keywords datasets
  ",
  "R/monthly_summary_doc.R"
)
