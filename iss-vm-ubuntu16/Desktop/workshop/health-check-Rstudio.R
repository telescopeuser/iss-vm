###########################################################
# working directory
###########################################################
getwd()
setwd("/home/iss-user/Desktop/workshop/")
getwd()

###########################################################
# distribution histogram
###########################################################
x <- rnorm(10000)
hist(x, breaks = 50)

###########################################################
# interactive visualization
###########################################################
library(shiny)
library(plotly)

ui <- fluidPage(
  plotlyOutput("plot"),
  verbatimTextOutput("event")
)

server <- function(input, output) {

  # renderPlotly() also understands ggplot2 objects!
  output$plot <- renderPlotly({
    plot_ly(mtcars, x = ~mpg, y = ~wt)
  })
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
}

shinyApp(ui, server)

###########################################################
# rattle for modeling
###########################################################
library("rattle")
rattleInfo()
rattle()
