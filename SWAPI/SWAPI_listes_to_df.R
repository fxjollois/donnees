rm(list = ls())

load(file = "SWAPI_listes.RData")

for (o in ls()) {
  assign(o, fromJSON(toJSON(get(o))))
}
rm(o)

# Functions 

get_id_from_url = function(url) {
  r = NA
  if (!is.null(url) & (length(url) > 0)) {
    r = as.integer(strsplit(url, "/")[[1]][6])
  }
  return (r)
}

get_table_from_liste_dans_df = function(df, liste, champs) {
  res = apply(df, 1, function (e) {
    res = NULL
    if (!is.null(e[liste][[1]])) {
      v = sapply(unlist(e[liste]), get_id_from_url)
      res = data.frame(a = e$id, b = v)
      rownames(res) = NULL
      colnames(res) = champs
    }
    return(res)
  })
  return (Reduce(function (a, b) { rbind(a, b) }, res))
} 

set_id_from_url = function(df) {
  n = names(df)
  df$id = sapply(df$url, get_id_from_url)
  df = df[, c("id", n)]
  df$url = NULL
  return (df)
}

#------------------------------------------------
# people

people = set_id_from_url(people)

people$specie = sapply(people$species, get_id_from_url)
people$species = NULL

people$homeworld = sapply(people$homeworld, get_id_from_url)

people_film = get_table_from_liste_dans_df(people, "films", c("people", "film"))
people$films = NULL

#people_vehicle = get_table_from_liste_dans_df(people, "vehicles", c("people", "vehicle"))
people$vehicles = NULL

#people_starship = get_table_from_liste_dans_df(people, "starships", c("people", "starship"))
people$starships = NULL

people$name = as.character(people$name)
people$height = suppressWarnings(as.numeric(people$height))
people$mass = suppressWarnings(as.numeric(people$mass))
people$hair_color = as.character(people$hair_color)
people$skin_color = as.character(people$skin_color)
people$eye_color = as.character(people$eye_color)
people$birth_year = as.character(people$birth_year)
people$gender = as.character(people$gender)

#------------------------------------------------
# starships

starships = set_id_from_url(starships)

starship_pilot = get_table_from_liste_dans_df(starships, "pilots", c("starship", "people"))
starships$pilots = NULL

starship_film = get_table_from_liste_dans_df(starships, "films", c("starship", "film"))
starships$films = NULL

starships$name = as.character(starships$name)
starships$model = as.character(starships$model)
starships$manufacturer = as.character(starships$manufacturer)
starships$cost_in_credits = suppressWarnings(as.numeric(starships$cost_in_credits))
starships$length = suppressWarnings(as.numeric(starships$length))
starships$max_atmosphering_speed = as.character(starships$max_atmosphering_speed)
starships$crew = as.character(starships$crew)
starships$passengers = as.character(starships$passengers)
starships$cargo_capacity = suppressWarnings(as.numeric(starships$cargo_capacity))
starships$consumables = as.character(starships$consumables)
starships$hyperdrive_rating = suppressWarnings(as.numeric(starships$hyperdrive_rating))
starships$MGLT = suppressWarnings(as.numeric(starships$MGLT))
starships$starship_class = as.character(starships$starship_class)

#------------------------------------------------
# planets

planets = set_id_from_url(planets)

residents = get_table_from_liste_dans_df(planets, "residents", c("planet", "people"))
planets$residents = NULL

planet_film = get_table_from_liste_dans_df(planets, "films", c("planet", "film"))
planets$films = NULL

planets$name = as.character(planets$name)
planets$rotation_period = suppressWarnings(as.numeric(planets$rotation_period))
planets$orbital_period = suppressWarnings(as.numeric(planets$orbital_period))
planets$diameter = suppressWarnings(as.numeric(planets$diameter))
planets$climate = as.character(planets$climate)
planets$gravity = as.character(planets$gravity)
planets$terrain = as.character(planets$terrain)
planets$surface_water = suppressWarnings(as.numeric(planets$surface_water))
planets$population = suppressWarnings(as.numeric(planets$population))

#------------------------------------------------
# vehicles

vehicles = set_id_from_url(vehicles)

vehicle_pilot = get_table_from_liste_dans_df(vehicles, "pilots", c("vehicle", "people"))
vehicles$pilots = NULL

vehicle_film = get_table_from_liste_dans_df(vehicles, "films", c("vehicle", "film"))
vehicles$films = NULL

vehicles$name = as.character(vehicles$name)
vehicles$model = as.character(vehicles$model)
vehicles$manufacturer = as.character(vehicles$manufacturer)
vehicles$cost_in_credits = suppressWarnings(as.numeric(vehicles$cost_in_credits))
vehicles$length = suppressWarnings(as.numeric(vehicles$length))
vehicles$max_atmosphering_speed = suppressWarnings(as.numeric(vehicles$max_atmosphering_speed))
vehicles$crew = suppressWarnings(as.numeric(vehicles$crew))
vehicles$passengers = suppressWarnings(as.numeric(vehicles$passengers))
vehicles$cargo_capacity = suppressWarnings(as.numeric(vehicles$cargo_capacity))
vehicles$consumables = as.character(vehicles$consumables)
vehicles$vehicle_class = as.character(vehicles$vehicle_class)

#------------------------------------------------
# species

species = set_id_from_url(species)

species$homeworld = sapply(species$homeworld, get_id_from_url)

specie_film = get_table_from_liste_dans_df(species, "films", c("specie", "film"))
species$films = NULL

species$people = NULL

species$name = as.character(species$name)
species$classification = as.character(species$classification)
species$designation = as.character(species$designation)
species$average_height = suppressWarnings(as.numeric(species$average_height))
species$skin_colors = as.character(species$skin_colors)
species$hair_colors = as.character(species$hair_colors)
species$eye_colors = as.character(species$eye_colors)
species$average_lifespan = as.character(species$average_lifespan)
species$language = as.character(species$language)
as.character(species$average_height)

#------------------------------------------------
# films

films = set_id_from_url(films)

films$characters = NULL
films$planets = NULL
films$starships = NULL
films$vehicles = NULL
films$species = NULL

films$title = as.character(films$title)
films$episode_id = as.integer(films$episode_id)
films$opening_crawl = as.character(films$opening_crawl)
films$director = as.character(films$director)
films$producer = as.character(films$producer)
films$release_date = as.Date(as.character(films$release_date))


# Nettoyage

rm(get_id_from_url, get_table_from_liste_dans_df, set_id_from_url)

save.image(file = "SWAPI_dataframes.RData")


