# ST558-Project4

Purpose
The purpose of creating this application was to analyse on the insurance data set and make predictions on what will be the insurance premium for a particular. This prediction plays an important role in insurance industry, where the policy maker need to make better business decision on what should be an ideal cost for an insurance.

In this app, user can perform Exploratory Data analysis on various features of the data with a functionality of manually choosing the feature they are interested. 

User can perform Linear Regression, Regression Tree and Random Forest to predict the insurance premium. User can also decide which model has better accuracy in prediciting the models.

At last, the user can view and download the data. User can select the number of rows and column they want to see.


Packages Required

library(shiny)

library(shinydashboard)

library(DT)

library(tidyverse)

library(psych)

library(caret)

library(leaps)

Install Packages

install.packages("shiny")

install.packages("shinydashboard")

install.packages("DT")

install.packages("tidyverse")


install.packages("psych")

install.packages("caret")

install.packages("leaps")

Code to Run App

shiny::runGitHub("ST558-Project4", "mjiwtan")
