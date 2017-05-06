
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Neural Net Approximation for Non-Linear Functions"),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h4("Application Overview"),
      div(
        p("This Shiny app will demonstrate the ability of a Neural Net model to approximate a non-linear function."),
        p("The user will be able to:"),
        tags$ul( 
         tags$li("Select one of two, non-linear functions ( y=x^2 or y=sin(x)+error )"),
         tags$li("Set the number of hidden neural net neurons (nodes) for Hidden Layer 1 and Layer 2,"),
         tags$li("Select a range for predictor variable X"),
         tags$li("Train a neural network"),
         tags$li("Plot the results")
        )  
       ),
      h4("Inputs"),
      div(
        selectInput("Function", "Function:",c("y=x^2" = "f1","y=sin(x)+error" = "f2")),
        sliderInput("xRange", "X Range:", min = -10, max =10, value = c(-5,5)),
        sliderInput("nNodesL1", "Layer 1 Hidden Nodes:", min = 10, max =20, value =10),
        sliderInput("nNodesL2", "Layer 2 Hidden Nodes:", min = 5, max =10, value =5),
        actionButton("btnTrain","Train Model and Visualize")
      ),
      h4("Note"),
      div(
        p("As you increase the range of X, you will need to increase the number of neurons in Layer 1 and Layer 2. Give it a try and hopefully the algorithm will converge!")
      ),
      hr(),
      h4("About"),
      div(
        span("Created by:"),tags$a(href="mailto:etsibert@hotmail.com" ,"Eric Tsibertzopoulos")
      )
      ),

    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Exploration",  plotOutput("mainPlot"), plotOutput("net")),
        tabPanel("Error", textOutput("MSE"),plotOutput("boxPlot")),
        tabPanel("Data",  tableOutput("df"))
      )
  
    )
  )
))
