library(shiny)
library(shinydashboard)

# Your code here
# Good luck :-)

ui <- dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody()
)

server <- function(input, output) {
  
}

shinyApp(ui, server)