
library(shiny)
library(stats)
library(lattice)
library(magrittr)
library(dplyr)
library(ggplot2)
library(gbm)
library(caret)
library(ggpubr)


cell1<-data.frame("cell"="cell_1", "cycle"=1:200, "Temperature"= 293, "Impedance"=4)
cell2<-data.frame("cell"="cell_2", "cycle"=1:200, "Temperature"= 273, "Impedance"=2)
cell3<-data.frame("cell"="cell_3", "cycle"=1:200, "Temperature"= 273, "Impedance"=5)
cell4<-data.frame("cell"="cell_4", "cycle"=1:200, "Temperature"= 315, "Impedance"=3)
cells<-rbind(cell1, cell2, cell3, cell4)


capacity<-function(cycle, impedance, temperature, noise){
        c<-numeric(length(cycle))
        for (i in 1:length(cycle)){
                c[i]<-100*exp(-cycle[i]/100/impedance[i])*exp(-10/temperature[i])*rnorm(1, mean = 1, sd=noise[i])
        }        
        c
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
        
        model1 <- reactive({
                # make the dataframe for prediction
                model_method<-input$method
                sd_input<-rep(input$sd, length(cells$cycle))
                c<-capacity(cells$cycle, cells$Impedance, cells$Temperature, sd_input)
                cells$capacity<-c
                
                df_input<-cells[, c("cycle", "Temperature", "Impedance", "capacity")]
                
                m<-train(data=df_input, capacity~., method=model_method)
                m
        })
        
         
        output$table<- renderTable({unique(cells[,c("cell", "Temperature", "Impedance")])})        


        output$Plot1 <- renderPlot({
                
                  # plots the measurements data
                sd_input<-rep(input$sd, length(cells$cycle))
                c_data<-capacity(cells$cycle, cells$Impedance, cells$Temperature, sd_input)
                cells$capacity<-c_data
        
                # plots the measurements data
                cell_user<-data.frame("cell"="Your_cell", "cycle"=1:200, "Temperature"=input$Temperature , "Impedance"=input$Impedance)
                c<-capacity(cell_user$cycle, cell_user$Impedance, cell_user$Temperature, rep(0.001, 200))
                cell_user$capacity<-c
                #plots the predicted model
                cell_prediction<-data.frame("cell"="Prediction", "cycle"=1:200, "Temperature"=input$Temperature , "Impedance"=input$Impedance)
                df_predict<-cell_prediction[, c("cycle", "Temperature", "Impedance")] 
                predm1<-predict(model1(), newdata=df_predict)
                cell_prediction$capacity<-predm1
                #join the data frames
                cell_user_pred<-rbind(cell_user,cell_prediction )
        
                
                gplot1<-ggplot()+geom_point(data=cells, aes(x=cycle, y=capacity, color=cell))+ 
                        coord_cartesian(xlim=c(0,200), ylim = c(30,110))+
                        xlab("Cycle number")+ylab("Capacity in %")+theme_set(theme_grey()) + 
                        ggtitle("Virtual measurements")
                
                gplot2<-ggplot()+geom_point(data=cell_user_pred, aes(x=cycle, y=capacity, color=cell))+ 
                        coord_cartesian(xlim=c(0,200), ylim = c(30,110))+
                        xlab("Cycle number")+ylab("Capacity in %")+theme_set(theme_grey()) + 
                        ggtitle("Your desired cell vs. the prediction")               
                
                p_tot<- ggarrange(gplot1,gplot2, nrow = 1, ncol=2) 
                p_tot
        
         })
        
           
})
