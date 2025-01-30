library(jsonlite)
library(tidyverse)

df = fromJSON("/Users/fxjollois/Documents/GitHub/donnees/movies.json")
df$fullplot = NULL
df$awards = NULL
df$`_id` = NULL
df$released = NULL
df$lastupdated = NULL
df$metacritic = NULL
df$plot = NULL
df$cast = NULL
df$num_mflix_comments = NULL
df$writers = NULL
df$directors = NULL

df$imdb_rating = df$imdb$rating
df$imdb = NULL
df$rt_rating = df$tomatoes$viewer$rating
df$tomatoes = NULL

premier = function(e) { return( ifelse(length(e) > 0, e[1], "Inconnu")) }
df$genres = sapply(df$genres, premier)
df$countries = sapply(df$countries, premier)
df$languages = sapply(df$languages, premier)

df$decade = round(as.numeric(substr(df$year, 1, 4)) / 10) * 10

write_csv(df, "movies_small.csv")
