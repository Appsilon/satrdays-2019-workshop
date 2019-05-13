library(shiny)

ui <- fluidPage(
  titlePanel("Hello Shiny!"),
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 5,
                  max = 20,
                  value = 10)
      
    ),
    
    mainPanel(
      plotOutput(outputId = "distPlot")
      
    )
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    
    x    <- iris$Sepal.Length
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins,
         xlab = "Sepal Length",
         main = "Histogram: Iris Sepal Length")
    
  })
  
}

shinyApp(ui = ui, server = server)