library(RSQLite)

db = dbConnect(RSQLite::SQLite(), "../Downloads/Chinook_Sqlite.sqlite")

for (t in dbListTables(db)) {
  df = dbReadTable(db, t)
  write.csv(df, file = paste0(t, ".csv"), row.names = FALSE, fileEncoding = "latin1")
}

cat(paste(paste0("%importation(", dbListTables(db), ");"), collapse = "\n"))

cat(paste(paste0("- [", dbListTables(db), "](csv/", dbListTables(db), ".csv)"), collapse = "\n"))

for (t in dbListTables(db)) {
  df = dbReadTable(db, t)
  assign(t, df)
}

dbDisconnect(db)

save.image(file = "Chinook.RData")
