

server <- function(input, output) {
  
  output$ui <- renderUI({
    if (is.null(input$dollar.Perc))
      return()
    
    # Depending on input$input_type, we'll generate a different
    # UI component and send it to the client.
    switch(input$dollar.Perc,
           "dollar" = sliderInput("down.payment",
                                  'Down Payment:',
                                  min = 10000,
                                  max = 500000,
                                  step = 1000,
                                  value = 50000),
           "perc" =  sliderInput("dperc",
                                 "Percentage of Downpayment:",
                                 min = 1,
                                 max = 50,
                                 step = .05,
                                 value = 20))})
  
  
  output$graphplaceholder <- renderPlot(plot(input$home.price))
  numbers = reactive({input$home.price - input$after.tax.income})
  # home.price
  # after.tax.income
  # years
  # interest.rate
  total_months <- reactive({12*input$years})
  mon_rate <- reactive({(input$interest.rate)/100/12})
  discount_rate <- reactive({1-((1+mon_rate())^-total_months())})
  dp <- reactive({input$home.price*.20})
  purchase.price <- reactive({input$home.price - dp()})
  final<- reactive({(purchase.price()*mon_rate()*total_months())/discount_rate()})
  monthly_cost <- reactive({final()/total_months()})
  remaining.income <- reactive({input$after.tax.income - monthly_cost()})

  
  output$scenario.table <- renderTable((t(data.frame("price" = input$home.price,
                                                   "Loan Amount" = purchase.price(),
                                                   "Annual Rate" = input$interest.rate,
                                                   "Monthly After Tax Income" = input$after.tax.income,
                                                   "Monthly Cost" = monthly_cost(),
                                                   "Remaining Income" = remaining.income(),
                                                   "Total Cost of House" = final()))),rownames= TRUE)
  
}

shinyApp(ui, server)