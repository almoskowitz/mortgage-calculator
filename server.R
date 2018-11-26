### server for Mortgage application

server <- function(input, output){
  
  target.house <- reactive({if(input$dp.percent == 'down.payment') {
    
    sale.price <- input$home.value
    downpayment <- input$down.payment
    loan.amount <- input$home.value - input$down.payment
    monthly.interest.rate <- input$interest.rate/100/12
    
    discount.rate <- (((1+monthly.interest.rate)^360)-1) / (monthly.interest.rate*(1+ monthly.interest.rate)^360)
    monthly.mortgage <- loan.amount/discount.rate
    
    property.tax <- (input$property.tax/100)*sale.price
    monthly.property.tax <- property.tax/12
    
    df <- data.table(sale.price, downpayment, input$interest.rate, loan.amount, monthly.property.tax) ##,
               #row.names = c('Sale Price', 'Downpayment', 'Interest Rate', 
                #             'Loan Amount', 'Monthly Property Tax'))
    colnames(df) <- c('Sale Price', 'Downpayment', 'Interest Rate', 'Loan Amount', 'Monthly Property Tax')
    
    df
    
  } else{input$down.percent/100}
})
  
  output$caption <- renderDataTable(target.house())
  

}


shinyApp(ui, server)


t(data.table(1,2,3,4,5))
