library(RSQLite)

sakila = dbConnect(RSQLite::SQLite(), "sakila.sqlite")

liste = dbListTables(sakila)

for (l in liste) {
  t = dbReadTable(sakila, l)
  assign(l, t)
}

dbDisconnect(sakila)
rm(sakila, liste, l, t)

save.image(file = "sakila.RData")

liste = ls()

for (l in liste) {
  write.table(get(l), file = paste0("csv/", l, ".csv"), row.names = FALSE, sep = ";", na = ".")
}
