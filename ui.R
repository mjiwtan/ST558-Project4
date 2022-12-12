library(shiny)
library(shinydashboard)
library(DT)

dashboardPage(
              dashboardHeader(title = "Insurance"),
              dashboardSidebar(
                sidebarMenu(
                  menuItem("About Page",tabName="about"),
                  menuItem("Data Exploration Page",tabName="data_exp"
                           ),
                  menuItem("Modeling Page",tabName = "model"),
                  menuItem("Data Page",tabName="data")
                )
              ),
              dashboardBody(
                tabItems(
                  tabItem(tabName = "about",
                          
                         
                          fluidRow(
                            column(12,
                                box(width=NULL,title="Purpose of the App",status="info",solidHeader = TRUE,
                                    h4("The aim for this application is to create a shiny app for the insurance of the data."),
                                    h4("The app will help in identifying in the insurance charges for the person. The app will contain information about 
                                        data, exploaratory data analysis and summaries of various features in the data.Along with that different machine learning models will be explained and how they performed on the actual data."))
                                    
                            )),
                            fluidRow(
                              column(12,
                                     box(width=NULL,title="Data",status="info",solidHeader = TRUE,
                                         h4("US health Insurance dataset can be helpful in a simple yet illuminating study in understanding the risk underwriting in Health Insurance, the interplay of various attributes of the insured and see how they affect the insurance premium."),
                                         h4("This dataset contains 1338 rows of insured data, where the Insurance charges are given against the following attributes of the insured: Age, Sex, BMI, Number of Children, Smoker and Region. There are no missing or undefined values in the dataset."),
                                         h4("The data set is taken from",a(href="https://www.kaggle.com/datasets/teertha/ushealthinsurancedataset?resource=download&select=insurance.csv","Insurance",style="font-size:20px;")))
                                        
                                         
                                         
                              )),
                              fluidRow(
                                column(12,
                                       box(width=NULL,title="Pages information",status="info",solidHeader = TRUE,
                                           h4("First Page: Purpose for developing this app"),
                                           h4("Second Page: Exploratory Data Analysis"),
                                           h4("Third Page: Modeling and Prediction"),
                                           h4("Fourth Page: Scrolling through the data"))
                                  
                                )),
                                fluidRow(
                                  column(12,
                                        
                                         imageOutput("image1")
                                             
                                  )
                            
                            
                          )
                  ),  #Tab item
                  tabItem(tabName = "data_exp",
                         
                          
                          fluidRow(
                            column(6,
                                   box(width=NULL,title="Categorical Summary",
                                       h5("Select two categorical variable for contigency table"),
                                       selectInput("variable1","First Variable",
                                                   c("Sex"="sex","Number of kids"="children",
                                                     "Smoking"="smoker",Area="region"),selected="sex"),
                                       selectInput("variable2","Second Variable",
                                                   c("Sex"="sex","Number of kids"="children",
                                                     "Smoking"="smoker",Area="region"),selected="smoker")
                                   )       
                            ),
                            column(6,
                                   box(width=NULL,title="Contingency Table",
                                       tableOutput("contingency_table"))
                            )
                          ),fluidRow(
                            column(3,
                                   box(width=NULL,height=405,title="Numerical Summary",
                                       checkboxGroupInput("num_summary",
                                                          "Variable selection for numerical summary",
                                                          c("Age"="age",
                                                            "BMI"="bmi","Number of kids"="children",
                                                            "Charges"="charges"),
                                                          selected=c("age","bmi","children","charges"))
                                   )
                            ),
                            column(9,
                                   box(width=NULL,title="Summary",
                                       dataTableOutput("numerical_summaries")
                                   )
                            )
                          ),
                          
                          fluidRow(
                            column(1
                            ),
                            column(10,align = "center",
                                   box(width=NULL,height=45,title="Bar Plots",background="orange")
                            ),
                            column(1
                            )
                          ),
                          fluidRow(
                            column(2,
                                   box(width=NULL,title="Plots for categorical variables",
                                       checkboxGroupInput("bar_plots",
                                                          "Bar Plots for selected variables",
                                                          c("Sex"="sex","Number of kids"="children",
                                                            "Smoking"="smoker",Area="region"),
                                                          selected=c("sex","children","smoker","region"))
                                   )
                            ),
                            column(10,
                                   fluidRow(
                                     column(12,
                                            
                                            
                                            conditionalPanel(
                                              condition = "input.bar_plots.includes('sex')",
                                              box(width=NULL,
                                                  plotOutput("plot_sex"))
                                            ),
                                            conditionalPanel(
                                              condition = "input.bar_plots.includes('children')",
                                              box(width=NULL,
                                                  plotOutput("plot_children"))
                                            ),
                                            conditionalPanel(
                                              condition = "input.bar_plots.includes('smoker')",
                                              box(width=NULL,
                                                  plotOutput("plot_smoker"))
                                            ),
                                            conditionalPanel(
                                              condition = "input.bar_plots.includes('region')",
                                              box(width=NULL,
                                                  plotOutput("plot_region"))
                                            ),
                                            
                                            
                                     )
                                   )
                            )
                          ),
                          fluidRow(
                            column(1
                            ),
                            column(10,align = "center",
                                   box(width=NULL,height=45,title="Scatterplot and Histogram",background="orange")
                            ),
                            column(1
                            )
                          ),
                          fluidRow(
                            column(2,
                                   box(width=NULL,title="Types of plot",
                                       selectInput("scatter_hist","Select between scatter plot or histogram",
                                                   c("Scatterplot"="scatter","Histogram"="hist",
                                                     "Scatterplot and Histogram"="both_scatter_hist"),selected="scatter")
                                   )),
                            
                            
                            column(5,
                                   conditionalPanel(
                                     condition = "input.scatter_hist == 'scatter'",
                                     box(width=NULL,
                                         plotOutput('plot1')
                                     )),
                                   conditionalPanel(
                                     condition = "input.scatter_hist == 'hist'",
                                     box(width=NULL,
                                         plotOutput('plot3')
                                     )),
                                   conditionalPanel(
                                     condition = "input.scatter_hist == 'both_scatter_hist'",
                                     
                                     box(width=NULL,
                                         plotOutput("plot5")
                                     ),
                                     box(width=NULL,
                                         plotOutput("plot7")
                                     )
                                   )      
                            ),
                            column(5,
                                   conditionalPanel(
                                     condition = "input.scatter_hist == 'scatter'",
                                     box(width=NULL,
                                         plotOutput('plot2')
                                     )),
                                   conditionalPanel(
                                     condition = "input.scatter_hist == 'hist'",
                                     box(width=NULL,
                                         plotOutput('plot4')
                                     )),
                                   conditionalPanel(
                                     condition = "input.scatter_hist == 'both_scatter_hist'",
                                     box(width=NULL,
                                         plotOutput("plot6")
                                     ),
                                     box(width=NULL,
                                         plotOutput("plot8")
                                     )
                                   )   
                            )
                          )
                          
                  ), #tabItem
                  tabItem(tabName = "model",
                          tabsetPanel(
                            tabPanel("Modeling Info",
                                     fluidRow(
                                       column(12,
                                              box(width=NULL,title="Linear Regression",
                                                  status="info",solidHeader = TRUE,
                                                  h4("A variable's value can be predicted using linear regression analysis based on the value of another variable. The dependent variable is the one you want to be able to forecast. The independent variable is the one you're using to make a prediction about the value of the other variable."),
                                                  h4(""),
                                                  withMathJax(),
                                                  helpText('$$y = \\beta_0 + \\beta_1 \\cdot x_1 + 
                         \\beta_2 \\cdot x_2 + ... + \\beta_k \\cdot x_k$$'),
                                                 
                                                  h4("Here Y is the dependent variable, x1,x2....xk are independent variables and Betas are co-efficent of independe variables. Coefficients are the amount by which change in X must be multiplied to give the corresponding average change in Y."),
                                                  h4(tags$b("Benefits:"),
                                                     tags$br(),
                                                     "Linear regression performs exceptionally well for linearly separable data",
                                                     tags$br(),
                                                     "Easier to implement, interpret and efficient to train",
                                                     tags$br(),
                                                     "It handles overfitting pretty well using dimensionally reduction techniques, regularization, and cross-validation"),
                                                  h4(tags$b("Drawbacks:"),
                                                     tags$br(),
                                                     "The assumption of linearity between dependent and independent variables",
                                                     tags$br(),
                                                     "It is often quite prone to noise and overfitting",
                                                     tags$br(),
                                                     "It is prone to multicollinearity "
                   )
                                              )
                                       )
                                     ),
                                     fluidRow(
                                       column(12,
                                              box(width=NULL,title="Regression Decision Tree",
                                                  status="info",solidHeader = TRUE,
                                                  h4("Regression trees are decision trees with continuous target variables rather than class labels on the leaves. Modified split selection criteria and halting criteria are used with regression trees. The decisions may be explained, prospective outcomes can be seen, and potential events can be identified using a regression tree."),
                                                  
                                                  h4(tags$b("Benefits:"),
                                                     tags$br(),
                                                     "Compared to other algorithms decision trees requires less effort for data preparation during pre-processing.",
                                                     tags$br(),
                                                     "A decision tree does not require normalization and scaling of data",
                                                     tags$br(),
                                                     "A Decision tree model is very intuitive and easy to explain"),
                                                  h4(tags$b("Drawbacks:"),
                                                     tags$br(),
                                                     "A small change in the data can cause a large change in the structure of the decision tree causing instability.",
                                                     tags$br(),
                                                     "Decision tree often involves higher time to train the model.",
                                                     tags$br(),
                                                     "Need to prune them to reduce variance")
                                                  
                                              )
                                       )
                                     ),
                                     fluidRow(
                                       column(12,
                                              box(width=NULL,title="Random Forest Model",
                                                  status="info",solidHeader = TRUE,
                                                  h4("Random Forest develops on functionalities of Bagging. A number of multiple bootstrap samples are created with replacement and trees are fitted on these samples to predict the response variable. Random forest take average of these trees to arrive at a result. However random forest don't take all the feature for building the trees, unlike bagging. The features are selected at random which helps to reduce the correlation among the trees and hence reduces variance."),
                                                  
                                                  h4(tags$b("Benefits:"),
                                                     tags$br(),
                                                     "It solves the issue of overfitting in decision trees.",
                                                     tags$br(),
                                                     "It provides an effective way of handling missing data.",
                                                     tags$br(),
                                                     "It can produce a reasonable prediction without hyper-parameter tuning."),
                                                  h4(tags$b("Drawbacks:"),
                                                     tags$br(),
                                                     "It is a difficult tradeoff between the training time (and space) and increased number of trees.",
                                                     tags$br(),
                                                     "Random forest may not get good results for small data or low-dimensional data.",
                                                     tags$br(),
                                                     "Less interpretability.")
                                              )
                                       )
                                     )
                            ),
                            tabPanel("Model Fitting",
                                     fluidRow(
                                       column(1
                                       ),
                                       column(10,align = "center",
                                              box(width=NULL,height=45,title="Splitting the Data",background="green")
                                       ),
                                       column(1
                                       )
                                     ),
                                     fluidRow(
                                       column(1
                                       ),
                                       column(5,
                                              box(width=NULL,status="success",
                                                  sliderInput("split_number","Training Set proportion",
                                                              min=0.6,max=0.9,value=0.7,step=0.05))
                                       ),
                                       column(5,
                                              box(width =NULL,status = "info",align="center",background="green",
                                                  
                                                  actionButton("split","Click here to split Data"))
                                       ),
                                       column(1
                                       )
                                     ),
                                     fluidRow(
                                       column(12,align = "center",
                                              box(width=NULL,title="Linear Regression",align = "center",
                                                  status="success",solidHeader = TRUE,
                                                  checkboxGroupInput("train_var1","Select predictor variables:",
                                                                     c("Age "="age","BMI"="bmi","Sex"="sex",
                                                                       "Number of Children"="children",
                                                                       "Smoking"="smoker","Area"="region"),
                                                                     selected=c("age","sex","bmi")
                                              )
                                              )
                                       )
                                       ),
                                     fluidRow(
                                       column(8,align = "center",
                                              box(width=NULL,title="Regression Tree",align = "center",
                                                  status="success",solidHeader = TRUE,
                                                  checkboxGroupInput("train_var2","Select predictor variables:",
                                                                     c("Age "="age","BMI"="bmi","Sex"="sex",
                                                                       "Number of Children"="children",
                                                                       "Smoking"="smoker","Area"="region"),
                                                                       selected=c("age","sex","bmi")),
                                                  
                                              
                                       )
                                       ),
                                       column(4,align = "center",
                                              box(width=NULL,title="Tuning Regression Tree",align = "center",
                                                  status="success",solidHeader = TRUE,
                                         sliderInput("max_depth","Select the max depth of the tree",
                                                     min=2,max=10,value=6,step=1)
                                       )
                                     )
                                     ),
                                     fluidRow(
                                       column(8,align = "center",
                                              box(width=NULL,title="Random Forest",align = "center",
                                                  status="success",solidHeader = TRUE,
                                                  checkboxGroupInput("train_var3","Select predictor variables:",
                                                                     c("Age "="age","BMI"="bmi","Sex"="sex",
                                                                       "Number of Children"="children",
                                                                       "Smoking"="smoker","Area"="region"),
                                                                       selected=c("age","sex","bmi")),
                                                  
                                              )
                                       ),
                                       column(4,align = "center",
                                              box(width=NULL,title="Tuning Random Forest",align = "center",
                                                  status="success",solidHeader = TRUE,
                                                  sliderInput("mtry","Select the  number of variables to randomly sample as candidates at each split",
                                                   min=2,max=5,value=3,step=1)
                                              )
                                       )
                                    
                                     ),
                                     fluidRow(
                                       column(2),
                                       column(8,align = "center",
                                              box(width=NULL,background="green",
                                                 
                                                  
                                                  actionButton(inputId="model_train",label="Click here to fit the model")
                                                  
                                              )
                                       ),
                                       column(2)
                                     ),
                                     fluidRow(
                                       column(12,
                                              box(width=NULL,title="Linear Regression Performance Metrics",
                                                  status="info",solidHeader = TRUE,
                                                  column(4,
                                                  h5(tags$b("Training accuracy:")),
                                                  verbatimTextOutput("linear_train_rmse"),
                                                  
                                              ),
                                              column(4,
                                                     h5(tags$b("Summary:")),
                                                     verbatimTextOutput("linear_summary")
                                              
                                              ),
                                              column(4,
                                                     h5(tags$b("Test Accuracy:")),
                                                     verbatimTextOutput("linear_test_rmse")
                                                     
                                              )
                                              
                                       )
                                       )
                                       ),
                                     fluidRow(
                                       column(12,
                                              box(width=NULL,title="Regression Tree Performance Metric",
                                                  status="success",solidHeader = TRUE,
                                                  column(4,
                                                  h5(tags$b("Training accuracy:")),
                                                  verbatimTextOutput("decision_tree_train_rmse")
                                                  
                                                  ),
                                                  column(4,
                                                         h5(tags$b("Summary:")),
                                                         verbatimTextOutput("decision_tree_summary")
                                                         
                                                  ),
                                                  column(4,
                                                         h5(tags$b("Testing accuracy:")),
                                                         verbatimTextOutput("decision_tree_test_rmse")
                                                         
                                                  )  
                                              )
                                       )),
                                     fluidRow(
                                       column(12,
                                              box(width=NULL,title="Random Forest Performance Metric",
                                                  status="success",solidHeader = TRUE,
                                                  column(4,
                                                  h5(tags$b("Training accuracy:")),
                                                  verbatimTextOutput("train_stats_rf")
                                                  ),
                                                  column(4,
                                                         h5(tags$b("Summary:")),
                                                         verbatimTextOutput("rf_summary")
                                                  ),
                                                  column(4,
                                                         h5(tags$b("Training accuracy:")),
                                                         verbatimTextOutput("rf_test_rmse")
                                                  )
                                                  
                                              )
                                       )
                                     ),
                                     
                            ),
                            tabPanel("Prediction",
                                     
                                     fluidRow(
                                       column(2),
                                       column(8,
                                              box(width=NULL,
                                                  selectInput("model_input","Select the model you want to use 
                              for prediction",
                                                              c("Binary Logistic Regression"="lg",
                                                                "Classification Tree"="tree",
                                                                "Random Forest"="rf"),selected="lg")
                                              )     
                                       ),
                                       column(2)
                                     ),
                                     fluidRow(
                                       column(3),
                                       column(6,
                                              box(width=NULL,status="info",align="center",
                                                  h4("NOTE"),
                                                  h5("In the Model Fitting tab (previous tab), please train the 
                     selected model on all the variables before proceeding with Prediction")
                                              )
                                       ),
                                       column(3)
                                     ),
                                     fluidRow(
                                       column(1),
                                       column(5,
                                              box(width=NULL,title="Select the values of predictors",
                                                  numericInput("p_age","Age",min=29,max=77,value=50,step=2,
                                                               width=300),
                                                  selectInput("p_sex","Sex",c("Male"=1,"Female"=0),selected=1,
                                                              width=300),
                                                  selectInput("p_cp","Chest pain type",
                                                              c("Typical Angina"=0,"Atypical Angina"=1,
                                                                "Non-Anginal"=2,"Aysmptomatic"=3),selected=0,
                                                              width=300),
                                                  numericInput("p_trestbps","Resting Blood pressure",
                                                               min=94,max=200,value=130,step=2,width=300),
                                                  numericInput("p_chol","Cholestrol level",
                                                               min=126,max=564,value=200,step=10,width=300),
                                                  selectInput("p_fbs","Fasting blood sugar greater than 120 mg/dl",
                                                              c("Yes"=1,"No"=0),selected=0,width=300),
                                                  selectInput("p_restecg","Resting ECG",
                                                              c("Normal"=0,"Having ST-T wave abnormality"=1,
                                                                "Showing left ventricular hypertrophy"=2),
                                                              selected=0,width=300),
                                                  numericInput("p_thalach","Max. Heart rate",
                                                               min=71,max=202,value=90,step=2,width=300),
                                                  selectInput("p_exang","Exercise Induced Angina",
                                                              c("Yes"=1,"No"=0),selected=0,width=300),
                                                  numericInput("p_oldpeak","ST depression induced by exercise 
                               relative to rest",
                                                               min=0,max=6.2,value=4,step=0.1,width=300),
                                                  selectInput("p_slope","Slope of the peak exercise ST segment",
                                                              c("0"=0,"1"=1,"2"=2),selected=1,width=300),
                                                  selectInput("p_thal","Blood disorder(thalassemia)",
                                                              c("Normal"=1,"Fixed defect"=2,"Reversable defect"=3),
                                                              selected=1,width=300),
                                              )
                                       ),
                                       column(5,
                                              box(width=NULL,title="Prediction",solidHeader=TRUE,
                                                  status="info",align="center",
                                                  textOutput("final_prediction"))
                                       ),
                                       column(1)
                                     ),
                            )
                          )
                  ), #tabItem
                  tabItem(tabName = "data",
                          fluidRow(
                            column(3),
                            column(6,align = "center",
                                   box(width=NULL,height=45,background="red",
                                       title="Get Dataset"
                                   )
                            ),
                            column(3)
                          ),
                          fluidRow(
                            column(2),
                            column(8,
                                   box(width=NULL,height=150,align="center",
                                       h5("You can use this page to obtain the csv file for the dataset."),
                                       h5("1. Select the variables you want from the dataset."),
                                       h5("2. Select",tags$b("Offset:"),"The record number from which you want to get the data."),
                                       h5("3. Select",tags$b("Count:"),"The number of record you want in your dataset"),
                                       h5("4. Download CSV")
                                   )
                            ),
                            column(2),
                          ),
                          fluidRow(
                            column(3,
                                   box(width=NULL,
                                       checkboxGroupInput("get_data","Select predictor variables:",
                                                          c("Age (age)"="age","Sex (sex)"="sex",
                                                            "Chest pain type (cp)"="cp",
                                                            "Resting blood pressure (trestbps)"="trestbps",
                                                            "Cholestrol (chol)"="chol",
                                                            "Fasting blood sugar (fbs)"="fbs",
                                                            "Resting ECG (restecg)"="restecg",
                                                            "Max. heart rate (thalach)"="thalach",
                                                            "Exercise induced angina (exang)"="exang",
                                                            "ST depression induced (oldpeak)"="oldpeak",
                                                            "Slope (slope)"="slope",
                                                            "Blood disorder (thal)"="thal","Target"="target"),
                                                          selected=c("age","sex","chol","fbs","thalach","cp",
                                                                     "trestbps","restecg","exang","oldpeak",
                                                                     "slope","thal","target")),
                                       numericInput("offset","Select offset value",
                                                    min=0,max=1020,value=0,step=1,width=300),
                                       numericInput("count","Select count value",
                                                    min=5,max=1025,value=100,step=1,width=300),
                                       downloadButton('download',"Download CSV")
                                   )
                            ),
                            column(9,
                                   box(width=NULL,
                                       dataTableOutput("data_csv"))
                            )
                          )
                  ) #tabItem
                ) #tabItems
              ) #dashboardBody
) #dashboardPage