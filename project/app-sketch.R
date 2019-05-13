library(dplyr)
library(shiny)
library(semantic.dashboard)
library(ggvis)
library(purrrlyr)
library(shiny.semantic)

source("utils.R")

ui <- dashboardPage(
  dashboardHeader( title = "Movies App"
  ),
  dashboardSidebar(
    size = "thin", color = "teal",
    sidebarMenu(
      menuItem(tabName = "correlations", "Correlations"),
      menuItem(tabName = "best", "Best movies")
    )
  ),
  dashboardBody(
  )
)

server <- shinyServer(function(input, output, session) {

})

shinyApp(ui, server)
