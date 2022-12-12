library(shiny)
library(tidyverse)
library(caret)
library(leaps)
library(psych) 
library(corrplot)
data<-read_csv("insurance.csv")
data_original<-data
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
   
   output$image1<-renderImage({
     list(src='insurance_img.jpeg',width = "50%", height = '360px',align="center")
   })
 # Code for plotting scatterplot or histogram
   
    output$plot1<-renderPlot({
     
     if(input$scatter_hist=="scatter"){
       plot<- data %>% 
         select(age, bmi) %>% 
         group_by(age) %>% 
         summarise(Avg_BMI = mean(bmi))
       p<-ggplot(data = plot, aes(age,Avg_BMI)) + 
         labs(x="Age",y="Average BMI",title="AGE vs BMI") + 
         geom_point()+
         theme(plot.title = element_text(hjust = 0.5))
     }
     p
   })
    
    output$plot2<-renderPlot({
      
      if(input$scatter_hist=="scatter"){
        plot<- data %>% 
          select(age, charges) %>% 
          group_by(age) %>% 
          summarise(Avg_Charges = mean(charges))
        p<-ggplot(data = plot, aes(age,Avg_Charges)) + 
          labs(x="Age",y="Average Charges",title="AGE vs Charges") + 
          geom_point()+
          theme(plot.title = element_text(hjust = 0.5))
      }
      p
    })
    
    output$plot5<-renderPlot({
      
      if(input$scatter_hist=="both_scatter_hist"){
        plot<- data %>% 
          select(age, bmi) %>% 
          group_by(age) %>% 
          summarise(Avg_BMI = mean(bmi))
        p<-ggplot(data = plot, aes(age,Avg_BMI)) + 
          labs(x="Age",y="Average BMI",title="AGE vs BMI") + 
          geom_point()+
          theme(plot.title = element_text(hjust = 0.5))
      }
      p
    })
    output$plot6<-renderPlot({
      
      if(input$scatter_hist=="both_scatter_hist"){
        plot<- data %>% 
          select(age, charges) %>% 
          group_by(age) %>% 
          summarise(Avg_Charges = mean(charges))
        p<-ggplot(data = plot, aes(age,Avg_Charges)) + 
          labs(x="Age",y="Average Charges",title="AGE vs Charges") + 
          geom_point()+
          theme(plot.title = element_text(hjust = 0.5))
      }
      p
    })
    
    output$plot3<-renderPlot({
      if(input$scatter_hist=="hist"){
      p<-hist(data$age,main="Average Age of Insurance Holder",xlab="Age",color="magenta")
      }
      
      p
    })
    output$plot4<-renderPlot({
      if(input$scatter_hist=="hist"){
        p<-hist(data$bmi,main="Average BMI of Insurance Holder",xlab="BMI",color="magenta")
      }
      
      p
    })
    
    output$plot7<-renderPlot({
      if(input$scatter_hist=="both_scatter_hist"){
        p<-hist(data$age,main="Average Age of Insurance Holder",xlab="Age",color="magenta")
      }
      
      p
    })
    output$plot8<-renderPlot({
      if(input$scatter_hist=="both_scatter_hist"){
        p<-hist(data$bmi,main="Average BMI of Insurance Holder",xlab="BMI",color="magenta")
      }
      
      p
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
  
   # Splitting the data 
   splitting<-eventReactive(input$split,{
     
    input$split_number
    
   })
   
   # Selecting features for linear regression
   features_linear<-eventReactive(input$model_train,{
     val1<-c(input$train_var1)
   })
   output$linear_test_rmse<-renderText({
    split1<-splitting()
   feat_linear<-features_linear()
   linear_data<-data%>%select(feat_linear,charges)
   splitSize <- sample(nrow(linear_data), nrow(linear_data)*splitting())

     trainSet_linear <- linear_data[splitSize,]

   testSet_linear <- linear_data[-splitSize,]

   linear_fit<-lm(charges~.,data=trainSet_linear,trControl=trainControl(method = "repeatedcv", number = 5, repeats = 3))
    linear_predict=predict(linear_fit,testSet_linear)
    linear_test_rmse<-sqrt(mean((testSet_linear$charges-linear_predict)^2))
    print(linear_test_rmse)
   })
   
   output$linear_train_rmse<-renderText({
     split1<-splitting()
     feat_linear<-features_linear()
     linear_data<-data%>%select(feat_linear,charges)
     splitSize <- sample(nrow(linear_data), nrow(linear_data)*splitting())
     
     trainSet_linear <- linear_data[splitSize,]
     
     testSet_linear <- linear_data[-splitSize,]
     
     linear_fit<-lm(charges~.,data=trainSet_linear,trControl=trainControl(method = "repeatedcv", number = 5, repeats = 3))
     
     linear_predict=predict(linear_fit,trainSet_linear)
     linear_train_rmse<-sqrt(mean((trainSet_linear$charges-linear_predict)^2))
     print(linear_train_rmse)
     })
 
   # Fitting Decision Tree
   features_dt<-eventReactive(input$model_train,{
     val1<-c(input$train_var2)
   })
   
   tune_dt<-eventReactive(input$model_train,{
     val1<-c(input$tree_depth)
   })
   
   output$decision_tree_train_rmse<-renderText({
     split1<-splitting()
     feat_dt<-features_dt()
     dt_data<-data%>%select(feat_dt,charges)
     splitSize <- sample(nrow(dt_data), nrow(dt_data)*splitting())
     
     trainSet_dt <- dt_data[splitSize,]
     
     testSet_dt <- dt_data[-splitSize,]
     
   })
   
   output$decision_tree_test_rmse<-renderText({
     split1<-splitting()
     feat_dt<-features_dt()
     dt_data<-data%>%select(feat_dt,charges)
     splitSize <- sample(nrow(dt_data), nrow(dt_data)*splitting())
     
     trainSet_dt <- dt_data[splitSize,]
     
     testSet_dt <- dt_data[-splitSize,]
     
   })
   
   # Fitting Random forest
   
   features_rf<-eventReactive(input$model_train,{
     val1<-c(input$train_var3)
   })
   
   tune_rf<-eventReactive(input$model_train,{
     val1<-c(input$ntree)
   })
   
   output$rf_train_rmse<-renderText({
     split1<-splitting()
     feat_rf<-features_rf()
     rf_data<-data%>%select(feat_rf,charges)
     splitSize <- sample(nrow(rf_data), nrow(rf_data)*splitting())
     
     trainSet_rf <- rf_data[splitSize,]
     
     testSet_rf <- rf_data[-splitSize,]
     
     cv<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
     tuning<-expand.grid(.mtry=ncol(trainSet_rf)/3)
     ntrees=tune_rf()
     rf_fit <- train(charges~., 
                     data = trainSet_rf, 
                     method = "rf",
                     trControl=cv, 
                     preProcess = c("center", "scale"),
                     ntree=ntrees,
                     tuneGrid = tuning)
     rf_predict <- predict(rf_fit, newdata = trainSet_rf)
     rf_train_mse <- sqrt(mean((rf_predict - trainSet_rf$charges)^2))
     print(rf_train_mse)
     
     
   })
   
   output$rf_test_rmse<-renderText({
     split1<-splitting()
     feat_rf<-features_rf()
     rf_data<-data%>%select(feat_rf,charges)
     splitSize <- sample(nrow(rf_data), nrow(rf_data)*splitting())
     
     trainSet_rf <- rf_data[splitSize,]
     
     testSet_rf <- rf_data[-splitSize,]
     
     cv<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
     tuning<-expand.grid(.mtry=ncol(trainSet_rf)/3)
     ntrees=tune_rf()
     rf_fit <- train(charges~., 
                     data = trainSet_rf, 
                     method = "rf",
                     trControl=cv, 
                     preProcess = c("center", "scale"),
                     ntree=ntrees,
                     tuneGrid = tuning)
     rf_predict <- predict(rf_fit, newdata = testSet_rf)
     rf_test_mse <- sqrt(mean((rf_predict - testSet_rf$charges)^2))
     print(rf_test_mse)
     
   })
   
 # Prediction
   type_model<-reactive({
      input$select_model
    })
   
   parameters<-reactive({
     val<-c(input$v_age,input$v_sex,input$v_bmi,input$v_children,input$v_smoker,input$v_region)
   })
   
   output$final_prediction<-renderText({
     select_model<-type_model()
     
   if(select_model=="Linear Regression"){
     params<-parameters()
     split1<-splitting()
     splitSize <- sample(nrow(data), nrow(data)*splitting())
     
     trainSet_linear <- data[splitSize,]
     
     testSet_linear <- data[-splitSize,]
     linear_fit<-lm(charges~.,data=trainSet_linear,trControl=trainControl(method = "repeatedcv", number = 5, repeats = 3))
     
     predict_value<-predict(linear_fit,data.frame(age=as.numeric(params[[1]]),sex=as.factor(params[[2]]),bmi=as.numeric(params[[3]]),children=as.factor(params[[4]]),
                                                   smoker=as.factor(params[[5]]),region=as.factor(params[[6]])))
     
   }
     if(select_model=="Random Forest"){
       params<-parameters()
       split1<-splitting()
       splitSize <- sample(nrow(data), nrow(data)*splitting())
       
       trainSet_rf <- data[splitSize,]
       
       testSet_rf <- data[-splitSize,]
       cv<-trainControl(method = "repeatedcv", number = 5, repeats = 3)
       tuning<-expand.grid(.mtry=ncol(trainSet_rf)/3)
       ntrees=tune_rf()
       rf_fit <- train(charges~., 
                       data = trainSet_rf, 
                       method = "rf",
                       trControl=cv, 
                       preProcess = c("center", "scale"),
                       ntree=ntrees,
                       tuneGrid = tuning)
       predict_value <- predict(rf_fit, data.frame(age=as.numeric(params[[1]]),sex=as.factor(params[[2]]),bmi=as.numeric(params[[3]]),children=as.factor(params[[4]]),
                                                smoker=as.factor(params[[5]]),region=as.factor(params[[6]])))
       
       
       
     }
     predict_value
   })
   
# Reading the data and downloading it  
   reading<-reactive({
     val1<-c(input$subset_data)
   })
   num_rows<-reactive({
     input$nrows
   })
   
   output$data_csv<-renderDataTable({
     subsetting<-reading()
     size=num_rows()
     df_subset<-data_original%>%select(subsetting)
     df_subset[c(1:size),]
   })    
   
   # Download the data
   
   reading1<-eventReactive(input$download,{
     val1<-c(input$subset_data)
   })
   num_rows1<-reactive({
     data_original[c(1:input$nrows),]
   })
   output$download <- downloadHandler(
     filename = function() { 
       paste("Insurance1", Sys.Date(), ".csv", sep="")
     },
     content = function(file) {
       final_data<-num_rows1()%>%select(reading())
       
       write.csv(final_data , file)
     })
})
