
<!-- README.md is generated from README.Rmd. Please edit that file -->

# YarraWaterAnalysis

<!-- badges: start -->

<!-- badges: end -->

The `YarraWaterAnalysis` package provides tools for analyzing and
visualizing streamflow data from the Yarra River at McMahons monitoring
site.

## Installation

You can install the development version of YarraWaterAnalysis from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
#devtools::install_github("etc5523-2025/rpkg-YarraWaterAnalysis")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(YarraWaterAnalysis)
## basic example code
```

## Calculate Flow Statistics

``` r
calculate_flow_stats(yarra_water_data)
```

You can use this function to calculate basic statistics for Yarra River
streamflow data

## analyze_seasonal_patterns

``` r
# Analyze seasonal patterns
seasonal_stats <- analyze_seasonal_patterns(yarra_water_data)
print(seasonal_stats)
#> # A tibble: 4 × 6
#>   season avg_flow median_flow max_flow min_flow n_observations
#>   <chr>     <dbl>       <dbl>    <dbl>    <dbl>          <int>
#> 1 Autumn     248.          75    14085        0           3347
#> 2 Summer     272.         102     6131        0           3535
#> 3 Winter     922.         283    17245        0           3407
#> 4 Spring    1023.         366    18687        0           3823
```

You can use this function to analyze seasonal patterns

## detect_high_flow_events

    #> # A tibble: 6 × 18
    #>   site_id site_name   datetime            data_type parameter_id parameter value
    #>     <dbl> <chr>       <dttm>              <chr>            <dbl> <chr>     <dbl>
    #> 1  229143 YARRA @ CH… 1975-10-26 23:59:59 Quantity          142. Streamfl… 18687
    #> 2  229142 YARRA @ TE… 1975-10-26 23:59:59 Quantity          142. Streamfl… 17399
    #> 3  229143 YARRA @ CH… 1977-07-01 23:59:59 Quantity          142. Streamfl… 17245
    #> 4  229143 YARRA @ CH… 1975-10-27 23:59:59 Quantity          142. Streamfl… 16014
    #> 5  229143 YARRA @ CH… 1977-06-20 23:59:59 Quantity          142. Streamfl… 15849
    #> 6  229143 YARRA @ CH… 1977-06-19 23:59:59 Quantity          142. Streamfl… 15164
    #> # ℹ 11 more variables: unit <chr>, quality <dbl>, resolution <chr>,
    #> #   date <date>, year <dbl>, month <ord>, day <int>, season <chr>,
    #> #   flow_category <chr>, log_flow <dbl>, flow_7day_avg <dbl>

You can use this function to detect high flow event

## Interactive Exploration

Launch the Shiny application for interactive data exploration:

``` r
# Launch the interactive app
# launch_app()
```

The Shiny app provides:

- Interactive time series visualization
- Seasonal pattern analysis
- Flow duration curves
- Statistical summaries
- Data filtering capabilities
