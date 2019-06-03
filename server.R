library(dplyr)

server <- function(input, output) {
  
  output$ui <- renderUI({
    if (is.null(input$dollar.Perc))
      return()
    
    # Depending on input$input_type, we'll generate a different
    # UI component and send it to the client.
    switch(input$dollar.Perc,
           "dollar" = sliderInput("down.payment",
                                  'Down Payment Option 1:',
                                  min = 10000,
                                  max = 500000,
                                  step = 1000,
                                  value = input$home.price*.20),
           "perc" =  sliderInput("dperc",
                                 "Percentage of Downpayment:",
                                 min = 1,
                                 max = 50,
                                 step = .05,
                                 value = 20))})
  
  
  output$graphplaceholder <- renderPlot(plot(input$home.price))
  
  
  total_months <- reactive({12*input$years})
  mon_rate <- reactive({(input$interest.rate)/100/12})
  discount_rate <- reactive({1-((1+mon_rate())^-total_months())})
  
  ### This is throwing an error 
  ### arguments imply different number of rows 1,0 not sure why
  
  
  ### Turning downpayment into a reactive function based on the selector
  
  dp <- reactive({
    if(input$dollar.Perc == 'dollar'){
      return(input$down.payment)
    } else if (input$dollar.Perc == 'perc') {
      return(input$home.price * input$dperc/100)
    }})
  
  loan.amount <- reactive({input$home.price - dp()})
  final<- reactive({(loan.amount()*mon_rate()*total_months())/discount_rate()})
  monthly_cost <- reactive({final()/total_months()})
  remaining.income <- reactive({input$after.tax.income - monthly_cost()})
  closing.costs.low <- reactive({input$home.price * .02})
  closing.costs.high <- reactive({input$home.price * .05})
  closing.costs.mid <- reactive((closing.costs.high() - closing.costs.low())/2 + closing.costs.low())

  dynamic.df <- function(price.variant,scenario){
      df<-reactive({data.frame("price" = input$home.price,
             "Down Payment" = dp() + price.variant,
             "Loan Amount" = loan.amount(),
             "Annual Rate" = input$interest.rate,
             "Monthly After Tax Income" = input$after.tax.income,
             "Monthly Cost" = monthly_cost(),
             "Remaining Income" = remaining.income(),
             "Closing Cost Mid" = closing.costs.mid(),  
             "Total Cash Needed for Purchase" = dp() + closing.costs.mid(),
             "Total Cost of House" = final(), row.names = c(scenario))})
      return(df())
      
      }
  
  
  # output$scenario.table <- renderTable((t(data.frame("price" = input$home.price,
  #                                                    "Down Payment" = dp(),
  #                                                  "Loan Amount" = purchase.price(),
  #                                                  "Annual Rate" = input$interest.rate,
  #                                                  "Monthly After Tax Income" = input$after.tax.income,
  #                                                  "Monthly Cost" = monthly_cost(),
  #                                                  "Remaining Income" = remaining.income(),
  #                                                  "Closing Cost Mid" = closing.costs.mid(),  
  #                                                  "Total Cash Needed for Purchase" = dp() + closing.costs.mid(),
  #                                                  "Total Cost of House" = final()))),rownames= TRUE)
  
  #results1<- dynamic.df(0,"Scenario 1")
  
  output$scenario.table <- renderTable(cbind(t(dynamic.df(0, "Scenario 1")),
                                 t(dynamic.df(input$downpayment.var2, "Scenario 2")),
                                 t(dynamic.df(input$downpayment.var3, "Scenario 3"))), rownames = TRUE)

  
  }

shinyApp(ui, server)