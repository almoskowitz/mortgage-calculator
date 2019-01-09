#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- shinyUI(fluidPage(
  
  # Application title
  titlePanel("Mortgage Calculator"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput(inputId = "homeprice",
                   label ="Home Price:",
                   min = 100000,
                   max = 3000000,
                   step = 10000,
                   value = 500000),
       sliderInput("aftertaxincome",
                   "After Tax Income:",
                   min = 1000,
                   max = 50000,
                   step = 100,
                   value = 4000),
       sliderInput("years",
                   "Duration of Loan:",
                   min = 10,
                   max = 30,
                   step = 5,
                   value = 30),
       sliderInput("rate",
                   "Annual Rate:",
                   min = 1.0,
                   max = 10.0,
                   step = .01,
                   value = 4.25),
       selectInput("dollarPerc", "Down Payment Option",
                   c(Dollar = 'dollar',
                     Percent = 'perc')),
       conditionalPanel(
         condition = "input.dollarPerc == 'dollar'",
         sliderInput("downpayment",
                     'Down Payment:',
                     min = 10000,
                     max = 500000,
                     step = 1000,
                     value = 50000)),
         conditionalPanel(
         condition = "input.dollarPerc == 'perc'",
         sliderInput("dperc",
                     "Percentage of Downpayment:",
                     min = 1,
                     max = 50,
                     step = .05,
                     value = 20))),
       
       mainPanel(
         plotOutput(outputId = 'distPlot')
       )
       )       ))



