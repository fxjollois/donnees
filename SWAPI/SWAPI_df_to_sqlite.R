rm(list = ls())

load(file = "SWAPI_dataframes.RData")
liste_df = ls()

library(RSQLite)

if (file.exists("SWAPI.sqlite"))
  file.remove("SWAPI.sqlite")
sw = dbConnect(RSQLite::SQLite(), "SWAPI.sqlite")

dbExecute(sw, "
CREATE TABLE `films` (
  `id` INTEGER NOT NULL PRIMARY KEY,
  `title` TEXT,
  `episode_id` INTEGER NOT NULL UNIQUE,
  `opening_crawl` TEXT,
  `director` TEXT,
  `producer` TEXT,
  `release_date` REAL
);")
dbAppendTable(sw, "films", films)

dbExecute(sw, "
CREATE TABLE `planets` (
  `id` INTEGER NOT NULL PRIMARY KEY,
  `name` TEXT,
  `rotation_period` REAL,
  `orbital_period` REAL,
  `diameter` REAL,
  `climate` TEXT,
  `gravity` TEXT,
  `terrain` TEXT,
  `surface_water` REAL,
  `population` REAL
);")
dbAppendTable(sw, "planets", planets)

dbExecute(sw, "
CREATE TABLE `species` (
  `id` INTEGER NOT NULL PRIMARY KEY,
  `name` TEXT,
  `classification` TEXT,
  `designation` TEXT,
  `average_height` REAL,
  `skin_colors` TEXT,
  `hair_colors` TEXT,
  `eye_colors` TEXT,
  `average_lifespan` TEXT,
  `homeworld` INTEGER REFERENCES planets (id),
  `language` TEXT
);")
dbAppendTable(sw, "species", species)

dbExecute(sw, "
CREATE TABLE `people` (
  `id` INTEGER NOT NULL PRIMARY KEY,
  `name` TEXT,
  `height` REAL,
  `mass` REAL,
  `hair_color` TEXT,
  `skin_color` TEXT,
  `eye_color` TEXT,
  `birth_year` TEXT,
  `gender` TEXT,
  `homeworld` INTEGER REFERENCES planets (id),
  `specie` INTEGER REFERENCES species (id)
);")
dbAppendTable(sw, "people", people)

dbExecute(sw, "
CREATE TABLE `starships` (
  `id` INTEGER NOT NULL PRIMARY KEY,
  `name` TEXT,
  `model` TEXT,
  `manufacturer` TEXT,
  `cost_in_credits` REAL,
  `length` REAL,
  `max_atmosphering_speed` TEXT,
  `crew` TEXT,
  `passengers` TEXT,
  `cargo_capacity` REAL,
  `consumables` TEXT,
  `hyperdrive_rating` REAL,
  `MGLT` REAL,
  `starship_class` TEXT
);")
dbAppendTable(sw, "starships", starships)

dbExecute(sw, "
CREATE TABLE `vehicles` (
  `id` INTEGER NOT NULL PRIMARY KEY,
  `name` TEXT,
  `model` TEXT,
  `manufacturer` TEXT,
  `cost_in_credits` REAL,
  `length` REAL,
  `max_atmosphering_speed` REAL,
  `crew` REAL,
  `passengers` REAL,
  `cargo_capacity` REAL,
  `consumables` TEXT,
  `vehicle_class` TEXT
)")
dbAppendTable(sw, "vehicles", vehicles)


dbExecute(sw, "
CREATE TABLE `people_film` (
  `people` INTEGER REFERENCES people (id),
  `film` INTEGER REFERENCES films (id),
  PRIMARY KEY (people, film)
);")
dbAppendTable(sw, "people_film", people_film)

dbExecute(sw, "
CREATE TABLE `planet_film` (
  `planet` INTEGER REFERENCES planets (id),
  `film` INTEGER REFERENCES films (id),
  PRIMARY KEY (planet, film)
);")
dbAppendTable(sw, "planet_film", planet_film)

dbExecute(sw, "
CREATE TABLE `residents` (
  `planet` INTEGER REFERENCES planets (id),
  `people` INTEGER REFERENCES people (id),
  PRIMARY KEY (planet, people)
);")
dbAppendTable(sw, "residents", residents)

dbExecute(sw, "
CREATE TABLE `specie_film` (
  `specie` INTEGER REFERENCES species (id),
  `film` INTEGER REFERENCES films (id),
  PRIMARY KEY (specie, film)
);")
dbAppendTable(sw, "specie_film", specie_film)

dbExecute(sw, "
CREATE TABLE `starship_film` (
  `starship` INTEGER REFERENCES starships (id),
  `film` INTEGER REFERENCES films (id),
  PRIMARY KEY (starship, film)
);")
dbAppendTable(sw, "starship_film", starship_film)

dbExecute(sw, "
CREATE TABLE `starship_pilot` (
  `starship` INTEGER REFERENCES starships (id),
  `people` INTEGER REFERENCES people (id),
  PRIMARY KEY (starship, people)
);")
dbAppendTable(sw, "starship_pilot", starship_pilot)

dbExecute(sw, "
CREATE TABLE `vehicle_film` (
  `vehicle` INTEGER REFERENCES vehicles (id),
  `film` INTEGER REFERENCES films (id),
  PRIMARY KEY (vehicle, film)
);")
dbAppendTable(sw, "vehicle_film", vehicle_film)

dbExecute(sw, "
CREATE TABLE `vehicle_pilot` (
  `vehicle` INTEGER REFERENCES vehicles (id),
  `people` INTEGER REFERENCES people (id),
  PRIMARY KEY (vehicle, people)
);")
dbAppendTable(sw, "vehicle_pilot", vehicle_pilot)

dbDisconnect(sw)
