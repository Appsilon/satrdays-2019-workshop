library(shiny)
library(shiny.semantic)

#' Displays Image Card
#'
#' @param img_path character with path to the image
#' @param content text to show below image
#'
#' @return div with card
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
))

server <- shinyServer(function(input, output) {
})

shiny::shinyApp(ui, server)
