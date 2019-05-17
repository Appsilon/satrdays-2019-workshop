library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "My Dashboard"),
  dashboardSidebar(
                   sidebarMenu(
                     menuItem(tabName = "plot1", text = "plot 1", icon = icon("home")),
                     menuItem(tabName = "plot2", text = "plot 2"),
                     menuItem(tabName = "plot3", text = "plot 3")
                   )),
  dashboardBody(tabItems(
    tabItem(tabName = "plot1", 
            box(plotOutput("plot1", height = 250)),
            box(title = "Controls",
                sliderInput("bins_n_1", label = "Number of bins", 0, 6, 3))),
    tabItem(tabName = "plot2", 
            box(plotOutput("plot2", height = 250)),
            box(title = "Controls",
                sliderInput("bins_n_2", label = "Number of bins", 0, 6, 3))),
    tabItem(tabName = "plot3", 
            box(plotOutput("plot3", height = 500)), 
            box(title = "controls", textInput("text", label = "Plot title"))) 
  ))
)

server <- function(input, output, session) {
  output$plot1 <- renderPlot({
    hist(iris$Sepal.Width, breaks = input$bins_n_1)
  })
  output$plot2 <- renderPlot({
    hist(iris$Sepal.Length, breaks = input$bins_n_2)
  })
  output$plot3 <-renderPlot({
    plot(iris$Sepal.Length, iris$Sepal.Width, main = input$text)
  })
  
}

shinyApp(ui, server)