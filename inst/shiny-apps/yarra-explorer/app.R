# inst/shiny-apps/yarra-explorer/app.R

library(shiny)
library(ggplot2)
library(dplyr)
library(lubridate)
library(plotly)

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "flatly"),

  titlePanel("Yarra River Streamflow Explorer"),

  sidebarLayout(
    sidebarPanel(
      width = 3,
      h4("Data Filters"),

      dateRangeInput("date_range", "Date Range:",
                     start = min(YarraWaterAnalysis::yarra_water_data$date),
                     end = max(YarraWaterAnalysis::yarra_water_data$date)),

      selectInput("plot_type", "Plot Type:",
                  choices = c("Time Series", "Seasonal Boxplot",
                              "Flow Duration Curve", "Monthly Summary")),

      sliderInput("flow_threshold", "High Flow Threshold (ML/day):",
                  min = 0, max = 500, value = 200, step = 10),

      checkboxInput("show_trend", "Show Trend Line", value = FALSE),
      checkboxInput("show_avg", "Show Moving Average", value = FALSE),

      actionButton("update_plot", "Update Analysis", class = "btn-primary"),

      br(), br(),
      h4("Interpretation Guide"),
      p("• Time Series: Shows daily flow variations over time"),
      p("• Seasonal: Compares flow patterns across seasons"),
      p("• Flow Duration: Shows percentage of time flow is exceeded"),
      p("• Monthly: Average flow patterns by month")
    ),

    mainPanel(
      width = 9,
      tabsetPanel(
        tabPanel("Visualization",
                 plotlyOutput("flow_plot", height = "500px"),
                 br(),
                 verbatimTextOutput("plot_description")
        ),
        tabPanel("Statistics",
                 h4("Summary Statistics"),
                 tableOutput("summary_stats"),
                 h4("High Flow Events"),
                 tableOutput("high_flow_table")
        ),
        tabPanel("Data",
                 h4("Filtered Data"),
                 DT::dataTableOutput("data_table")
        )
      )
    )
  )
)

server <- function(input, output, session) {

  # 反应式数据过滤
  filtered_data <- eventReactive(input$update_plot, {
    req(input$date_range)

    YarraWaterAnalysis::yarra_water_data %>%
      filter(date >= input$date_range[1] & date <= input$date_range[2])
  })

  # 主绘图函数
  output$flow_plot <- renderPlotly({
    data <- filtered_data()
    req(nrow(data) > 0)

    base_plot <- switch(input$plot_type,
                        "Time Series" = {
                          p <- ggplot(data, aes(x = date, y = value)) +
                            geom_line(aes(color = "Daily Flow"), alpha = 0.7) +
                            labs(title = "Yarra River Daily Streamflow",
                                 x = "Date", y = "Flow (ML/day)", color = "") +
                            theme_minimal()

                          if (input$show_avg) {
                            p <- p + geom_line(aes(y = flow_7day_avg, color = "7-day Average"),
                                               size = 1, na.rm = TRUE)
                          }

                          if (input$show_trend) {
                            p <- p + geom_smooth(method = "loess", se = FALSE,
                                                 aes(color = "Trend"), size = 1)
                          }

                          p
                        },

                        "Seasonal Boxplot" = {
                          ggplot(data, aes(x = season, y = value, fill = season)) +
                            geom_boxplot() +
                            labs(title = "Seasonal Flow Distribution",
                                 x = "Season", y = "Flow (ML/day)") +
                            theme_minimal() +
                            scale_fill_brewer(palette = "Set2")
                        },

                        "Flow Duration Curve" = {
                          fdc_data <- YarraWaterAnalysis::calculate_flow_duration(data)
                          ggplot(fdc_data, aes(x = exceedance_prob, y = value)) +
                            geom_line(color = "steelblue", size = 1) +
                            labs(title = "Flow Duration Curve",
                                 x = "Percentage of Time Flow Exceeded (%)",
                                 y = "Flow (ML/day)") +
                            theme_minimal()
                        },

                        "Monthly Summary" = {
                          monthly_data <- data %>%
                            group_by(month) %>%
                            summarise(avg_flow = mean(value, na.rm = TRUE))

                          ggplot(monthly_data, aes(x = month, y = avg_flow)) +
                            geom_col(fill = "steelblue", alpha = 0.7) +
                            labs(title = "Average Monthly Flow",
                                 x = "Month", y = "Average Flow (ML/day)") +
                            theme_minimal()
                        }
    )

    ggplotly(base_plot) %>%
      layout(hoverlabel = list(bgcolor = "white"))
  })

  # 绘图描述
  output$plot_description <- renderText({
    switch(input$plot_type,
           "Time Series" = "This time series plot shows daily streamflow variations. The 7-day moving average helps identify trends, while the trend line shows overall patterns.",
           "Seasonal Boxplot" = "Boxplots show flow distribution across seasons. The boxes represent interquartile range, whiskers show variability, and points indicate outliers.",
           "Flow Duration Curve" = "The flow duration curve shows the percentage of time that a given flow rate is exceeded. Steep curves indicate highly variable flow regimes.",
           "Monthly Summary" = "Bar chart showing average flow for each month. This helps identify seasonal patterns and monthly variations in river flow."
    )
  })

  # 汇总统计
  output$summary_stats <- renderTable({
    data <- filtered_data()
    stats <- YarraWaterAnalysis::calculate_flow_stats(data)
    data.frame(
      Statistic = c("Observations", "Mean Flow", "Median Flow", "Max Flow",
                    "Min Flow", "Std Deviation", "Coefficient of Variation"),
      Value = c(stats$n_observations, round(stats$avg_flow, 1),
                round(stats$median_flow, 1), round(stats$max_flow, 1),
                round(stats$min_flow, 1), round(stats$sd_flow, 1),
                round(stats$cv_flow, 3))
    )
  }, bordered = TRUE)

  # 高流量事件表
  output$high_flow_table <- renderTable({
    data <- filtered_data()
    high_flows <- YarraWaterAnalysis::detect_high_flow_events(data, input$flow_threshold)

    if (nrow(high_flows) > 0) {
      high_flows %>%
        select(date, value, flow_category) %>%
        head(10)  # 只显示前10个
    } else {
      data.frame(Message = "No high flow events found in the selected period")
    }
  }, bordered = TRUE)

  # 数据表
  output$data_table <- DT::renderDataTable({
    data <- filtered_data() %>%
      select(date, value, unit, season, flow_category)

    DT::datatable(data,
                  options = list(pageLength = 10, scrollX = TRUE),
                  rownames = FALSE)
  })
}

shinyApp(ui, server)
