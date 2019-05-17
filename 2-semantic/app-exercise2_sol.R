library(shiny)
library(shiny.semantic)

dispaly_image_card <- function(img_path, content = "animal") {
  div(class = "ui card",
      div(class = "image", 
          tags$img(src = img_path)
      ),
      div(class = "content",
          h4(content)
      )
  )
}

ui <- shinyUI(semanticPage(
  tabset(tabs =
           list(
             list(menu = "Dogs", content = uiOutput("tdog"), id = "dog"),
             list(menu = "Cats", content = uiOutput("tcat"), id = "cat")
           ),
         active = "dog",
         id = "tabset"
  )
))

server <- shinyServer(function(input, output) {
  observeEvent(input$tabset_tab,{
    output[[paste0("t", input$tabset_tab)]] <- renderUI({
      div(class="ui three cards",
        dispaly_image_card(paste0(input$tabset_tab, "1.jpeg"), input$tabset_tab),
        dispaly_image_card(paste0(input$tabset_tab, "2.jpeg"), input$tabset_tab),
        dispaly_image_card(paste0(input$tabset_tab, "3.jpeg"), input$tabset_tab)
      )
    })
  })
})

shiny::shinyApp(ui, server)
