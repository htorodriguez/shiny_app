
library(shiny)


shinyUI(fluidPage(
  
  # Application title
  titlePanel("Predicting the lifetime of a Li-ion battery"),
  h4("This app will predict the capacity retention of a Li-ion battery, based on virtual measurements"),
  h5("Description"),
  h6("This app will predict the capacity retention of a Li-ion Battery,
        based on simulated measurements. The objective of the app is to
        show how the noise in the measurement affects the prediction algorithm.
        This app assume that you have measured the capacity fade of 4 different cells
        at different temperatures and with different impedances. The cells you have in
        your virtual lab are displayed in the side bar. In your virtual lab, you can 
        use different equipment resulting in different noise in your measurement"),
  h5("Input"),
  h6("The first input of your virtual experiment is the noise in your measurements.
     Your measured cells are the bases for a regression model that runs in the background."),
  h5("Output"),
  h6("The main output is the prediction of the capacity fade out of your desired cell in the second plot. 
     We have also plotted the real capacity fade."),
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
