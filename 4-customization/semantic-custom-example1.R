library(shiny)
library(shiny.semantic)
library(semantic.dashboard)

ui <- dashboardPage(
  dashboardHeader(color = "blue"),
  dashboardSidebar(side = "left", size = "thin", color = "teal",
                   sidebarMenu(
                     menuItem(tabName = "tab1", "Tab 1")
                   )
  ),
  dashboardBody(tabItems(
    tabItem(tabName = "tab1",
            p("Tab 2")),
    # https://semantic-ui.com/elements/input.html
    div( class="ui left icon input loading",
         shiny_text_input(input_id="aa",
           tags$input(type = "text", placeholder = "Username")
         ),
         tags$i(class="search icon")
      )

    )
  )
)


server <- function(input, output) {
  observeEvent(input$aa,{
    print(input$aa)
  })
}

shinyApp(ui, server)
