library(shiny)
library(DT)
library(data.table)

# Define UI for application that draws a histogram
ui <- shinyUI(
  fluidPage(
  
  # Application title
  titlePanel("Mortgage Calculator"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "home.price",
                  label ="Home Price:",
                  min = 100000,
                  max = 3000000,
                  step = 5000,
                  value = 500000),
      sliderInput(inputId = "after.tax.income",
                  label = "Monthly After Tax Income:",
                  min = 1000,
                  max = 25000,
                  step = 50,
                  value = 4000),
      sliderInput(inputId = "years",
                  label = "Duration of Loan:",
                  min = 10,
                  max = 30,
                  step = 5,
                  value = 30),
      sliderInput(inputId = "interest.rate",
                  label = "Annual Rate:",
                  min = 1.0,
                  max = 10.0,
                  step = .01,
                  value = 4.25),
      selectInput(inputId = "dollar.Perc", 
                  label = "Down Payment Option",
                  c("Dollar" = 'dollar',
                    "Percent" = 'perc'),
                  selected = 'dollar'),
      
      uiOutput("ui")),
      
    mainPanel(
      
      #plotOutput("graphplaceholder"),
      br(), br(),
      
      tableOutput("scenario.table"),
      tableOutput("scenario.table2")
      
      
    )
  )))



