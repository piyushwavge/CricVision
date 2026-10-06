library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(ggplot2)
library(plotly)
library(dplyr)
library(DT)
library(randomForest)
library(caret)
library(reshape2)
library(scales)
library(RColorBrewer)

source("data.R")

cricket_data <- generate_cricket_data()

source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)