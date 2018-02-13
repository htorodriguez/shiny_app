
library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predicting the lifetime of a Li-ion battery"),
  h4("This app will predict the capacity retention of a Li-ion battery, based on virtual measurements"),
  h4("The objective is to see what is the influence of the noise of the measurement on the prediction quality"),

  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       h5("Set here the noise in your measurement"),
       sliderInput("sd", "Standard deviation of the noise", min = 0.01, max = 0.1, value = 0.05, step = 0.01),
       h5(" Your virtual cells are the following"),
       tableOutput("table"),
       h5("set here the cell impedance and temperature of the cell you want to predict"),
       sliderInput("Impedance","Impedance of cell to predict in Ohmcm2",  min = 1.0, max = 10.0, value = 4.0),
       sliderInput("Temperature", "Temperature of cell to predict in K", min = 263, max = 333, value = 273),
       selectInput("method", "Set the method for the prediction", choices = c("gbm", "lm") )      
       ),
    
    # Show a plot of the generated distribution
    mainPanel(
        h3("Results"),
        plotOutput("Plot1"),
        h5("As you can see, the predicting algorithm works pretty well even at very high noise levels, 
           but only if you estimate a cell that has impedance and temperature values between those used 
           for the training of the algorithm.")
        #plotOutput("Plot2")
    )
  )
))
