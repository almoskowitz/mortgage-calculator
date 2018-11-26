setwd("/Users/andrew.moskowitz/Documents/GitHub/mortgage-calculator")

library(shiny)
library(data.table)
library(tidyverse)

## set up vector of home prices in 25k increments
price <- seq(250000, 1500000, 25000)

ui <- pageWithSidebar(
  
  headerPanel("Mortgage Calculator"),
  
  sidebarPanel(
    
    sliderInput("home.value", "Price: ", 
                min = 250000, max =
                  1500000, value = 500000,
                step = 25000, pre = "$"), 
    
    selectInput("dp.percent", "Basis for Downpayment:  ", 
                c("$ Dollars" = 'down.payment',
                  "% Percent" = 'down.percent')),
    
    ### How do I get this one to reference the home value
    ### How do I connect slider values such that as one changes the other changes?
    sliderInput("down.payment", "Down Payment: ",
                min = 10000, max = 300000, value = 100000,
                step = 5000, pre = "$"),
    
    sliderInput("down.percent", "Down Payment Percentage: ", 
                min = 3.00, max = 25.00, value = 20,
                step = .10, post = "%"),
    
    sliderInput("interest.rate", "Interest Rate: ",
                min = 1.00, max = 10.00, value = 4.0,
                step = .05, post = "%"),
    
    sliderInput("property.tax", "Property Tax: ",
                min = .5, max  = 2.5, value = 1.0,
                step = .02, post = '%')
  ),
  
  mainPanel(
    
    dataTableOutput('caption')
  )
  
)


