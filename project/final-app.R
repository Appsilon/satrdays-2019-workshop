library(shiny)
library(semantic.dashboard)
library(ggvis)
library(purrrlyr)
library(shiny.semantic)

source("utils.R")

ui <- dashboardPage(
  dashboardHeader(color = "blue",
                  title = "Movies App",
                  dropdownMenuOutput("dropdown")
                  ),
  dashboardSidebar(
    size = "thin", color = "teal",
    sidebarMenu(
      menuItem(tabName = "correlations", "Correlations"),
      menuItem(tabName = "best", "Best movies")
    )
  ),
  dashboardBody(
    tabItems(
      selected = 1,
      tabItem(
        tabName = "correlations",
        fluidRow(
          box(color = "blue",
              title_side = "top left",
              width = 5,
              title = "Correlations",
              sliderInput("reviews", "Reviews", 10, 300, 40, step = 10),
              sliderInput("year", "Year released", 1940, 2014, value = c(1970, 2014),
                          sep = ""),
              selectInput("genre", "Genre", movie_genres)
          ),
          box(color = "green",
              width = 11,
              textOutput("n_oscar"),
              textOutput("n_no_oscar"),
              ggvisOutput("corrplot")
          )
        )
      ),
      tabItem(
        tabName = "best",
        fluidRow(
          box(color = "orange", width = 15,
              uiOutput("bestcards")
              )
        )
      )
    )
  )
)

server <- shinyServer(function(input, output, session) {
  output$dropdown <- renderDropdownMenu({
    dropdownMenu(
      notificationItem(input$genre, color = "teal", icon = "users"),
      notificationItem(paste(input$year[1]," - ", input$year[2]),
                       icon = "calendar", color = "red"),
      show_counter = FALSE
    )
  })

  movies <- reactive({
    reviews <- input$reviews
    minyear <- input$year[1]
    maxyear <- input$year[2]
    filter_all_movies(reviews, minyear, maxyear, input$genre)
  })
  
  vis <- reactive({
    movies %>%
      ggvis(x = ~Meter, y = ~imdbRating) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   stroke = ~has_oscar, key := ~ID) %>%
      add_axis("x", title = "Meter") %>%
      add_axis("y", title = "imdbRating") %>%
      set_options(width = 600, height = 400)
  })
  vis %>% bind_shiny("corrplot")
  output$n_oscar <- renderText({
    paste("Number of Oscar movies:", 
      nrow(movies() %>% filter(has_oscar=="Yes"))
    )
  })
  output$n_no_oscar <- renderText({ 
    paste("Number of movies without Oscar:", 
          nrow(movies() %>% filter(has_oscar=="No"))
    )
  })
  
  # ------------------------- SUBPAGE: best
  
  output$bestcards <- renderUI({
    uicards(class = "three", 
        movies() %>% arrange(desc(imdbRating)) %>% top_n(10, imdbRating) %>% 
        purrrlyr::by_row(~{
          uicard(div(class = "content",
                     div(class = "header", 
                         .$Title),
                     div(class = "meta",
                         paste("Director:", .$Director)),
                     div(class = "description",
                         paste("Cast:", .$Cast))
                     )
                 )
              }) %>% { .$.out })
  })
})

shinyApp(ui, server)
