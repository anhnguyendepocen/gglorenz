
<!-- README.md is generated from README.Rmd. Please edit that file -->
About `gglorenz`
================

The goal of `gglorenz` is to plot Lorenz Curves with the Blessing of `ggplot2`.

Installation
============

``` r
# install.packages("devtools")
devtools::install_github("jjchern/gglorenz")

# To uninstall the package, use:
# remove.packages("gglorenz")
```

Example
=======

Suppose you have a vector with each element represents the amount the stuff a person produced, and you are interested in knowing how much stuff are produced by the top x% of the people, then the `gglorenz::stat_lorenz(desc = TRUE)` would make a graph for you.

``` r
library(tidyverse)
library(gglorenz)

billionaires

billionaires %>%
    ggplot(aes(TNW)) +
    stat_lorenz(desc = TRUE) +
    coord_fixed() +
    geom_abline(linetype = "dashed") +
    theme_minimal() +
    hrbrthemes::scale_x_percent() +
    hrbrthemes::scale_y_percent() +
    labs(x = "Cumulative Percentage of the Top 500 Billionaires",
         y = "Cumulative Percentage of Total Net Worth",
         title = "Inequality Among Billionaires",
         caption = "Source: https://www.bloomberg.com/billionaires/")

billionaires %>%
    filter(Industry %in% c("Technology", "Real Estate")) %>%
    ggplot(aes(x = tnw, colour = Industry)) +
    stat_lorenz(desc = TRUE) +
    coord_fixed() +
    geom_abline(linetype = "dashed") +
    theme_minimal() +
    hrbrthemes::scale_x_percent() +
    hrbrthemes::scale_y_percent() +
    labs(x = "Cumulative Percentage of Billionaires",
         y = "Cumulative Percentage of Total Net Worth",
         title = "Real Estate is a Relatively Equal Field",
         caption = "Source: https://www.bloomberg.com/billionaires/")
```
