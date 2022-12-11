library(shiny)
library(tidyverse)
library(caret)
library(leaps)
library(psych) 
library(corrplot)
data<-read_csv("insurance.csv")

data$sex <- as.factor(data$sex)
data$sex <- factor(data$sex, levels = c("female", "male"), labels = c(0,1))
data$children<-as.factor(data$children)
data$smoker <- as.factor(data$smoker)
data$smoker <- factor(data$smoker, levels = c("no", "yes"), labels = c(0,1))
data$region <- as.factor(data$region)
data$region <- factor(data$region, levels = c("northeast", "northwest","southeast","southwest"), labels = c(0,1,2,3))
dataextra<-data

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  mydata<-reactive({
    val<-input$bar_plots
    })
  s <- reactive({
    val<-c(input$variable1,input$variable2)
  })
 
 output$contingency_table<-renderTable({
    contin<- s()
   
   table(dataextra[[contin[1]]],dataextra[[contin[2]]])
   
   })
 summaries<-reactive({
   val1<-c(input$num_summary)
 })
   output$numerical_summaries<-renderDataTable({
     summ<-summaries()
     df_summary<-data%>%select(summ)
     describe(df_summary)[,1:6]
   })
   
   
 
  output$plot_sex<- renderPlot({
    newdata=mydata()
    for (i in newdata){
    if(i=="sex"){
      dataextra$sex <- factor(dataextra$sex, levels = 0:1, labels =c("female", "male"))
      p<-ggplot(data=data, aes(x=sex,fill = sex, colour =sex)) +
        geom_bar(position = "dodge")
      }}
    p
      })
   output$plot_children<- renderPlot({
    newdata=mydata()
    for (i in newdata){
      if(i=="children"){
        p<-ggplot(data=dataextra, aes(x=children,fill = children, colour =children)) +
          geom_bar(position = "dodge")
      }}
    p
})
   output$plot_smoker<- renderPlot({
     newdata=mydata()
     for (i in newdata){
       if(i=="smoker"){
         dataextra$smoker <- factor(dataextra$smoker, levels = 0:1, labels =c("no", "yes"))
         p<-ggplot(data=dataextra, aes(x=smoker,fill = smoker, colour =smoker)) +
           geom_bar(position = "dodge")
       }}
     p
   })
   output$plot_region<- renderPlot({
     newdata=mydata()
     for (i in newdata){
       if(i=="region"){
         dataextra$region <- factor(dataextra$region, levels = 0:3, labels = c("northeast", "northwest","southeast","southwest"))
         p<-ggplot(data=dataextra, aes(x=region,fill = region, colour =region)) +
           geom_bar(position = "dodge")
       }}
     p
   })
 
 
})
