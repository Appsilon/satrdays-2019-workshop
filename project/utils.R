library(dplyr)
library(RSQLite)

# data loading

db <- src_sqlite("movies.db")
omdb <- tbl(db, "omdb")
tomatoes <- tbl(db, "tomatoes")

all_movies <- inner_join(omdb, tomatoes, by = "ID") %>%
  filter(Reviews >= 10) %>%
  select(ID, imdbID, Title, Year, Genre,
         Director, Writer, imdbRating, Oscars,
         Rating = Rating.y, Meter, Reviews, Rotten, Cast)

movie_genres <- c("All", "Action", "Adventure", "Animation", "Biography", "Comedy",
                  "Crime", "Documentary", "Drama", "Family", "Fantasy", "History",
                  "Horror", "Music", "Musical", "Mystery", "Romance", "Sci-Fi",
                  "Short", "Sport", "Thriller", "War", "Western")

#' Filter all_movies object
#' 
#' Based on the following parameters:
#'
#' @param reviews nr of reviews (numeric)
#' @param minyear minimal release year (numeric)
#' @param maxyear maximum release year (numeric)
#' @param genre genre from movie_genres (character)
#'
#' @return data.frame with filtered values according to above params
filter_all_movies <- function(reviews, minyear, maxyear, genre = "All") {
  m <- all_movies %>%
    filter(
      Reviews >= reviews,
      Year >= minyear,
      Year <= maxyear
    ) %>% arrange(Oscars)
  
  if (genre != "All") {
    genre <- paste0("%", genre, "%")
    m <- m %>% filter(Genre %like% genre)
  }
  
  m <- as.data.frame(m)
  m$has_oscar <- character(nrow(m))
  m$has_oscar[m$Oscars == 0] <- "No"
  m$has_oscar[m$Oscars >= 1] <- "Yes"
  m
}
