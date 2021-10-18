#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(plotly)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Prototype Pre Process Interface"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    
    sidebarPanel(
      
      fileInput("file","Choose CSV file", accept=c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
      
      
      checkboxInput("header", "Header", TRUE),
      
      
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),
      
      
      checkboxInput("Cutoffs",label="Cutoffs"),
      
      
      sliderInput("RT_min",
                  "RT Min:",
                  min = 1,
                  max = 1000,
                  value = 100),
      sliderInput("RT_max",
                  "RT Max:",
                  min = 500,
                  max = 10000,
                  value = 5000)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("distPlot"),
      
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  
  output$distPlot <- renderPlotly({
    req(input$file)
    
    df <- read.csv(input$file$datapath,header = input$header,
             sep = input$sep)
    
    df <- df%>% filter(RT > input$RT_min & RT < input$RT_max)
    disp <- ggplot(df) + geom_line(aes(x=VariableX,y=VariableY, color="red")) + geom_line(aes(x=VariableX, y=RT, color="blue"))
    
    ggplotly(disp)
    
  })    

  
}

# Run the application 
shinyApp(ui = ui, server = server)
