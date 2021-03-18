library(readxl)
library(stringr)
library(dplyr)
library(xlsx)

fichier = dir(pattern = "scimagojr [0-9]+.xlsx")

liste = lapply(fichier, function(f) {
  annee = str_split(str_split(f, " ")[[1]][2], "\\.")[[1]][1]
  test = cbind(Year = as.numeric(annee), read_excel(f))
  return(test)
})

res = Reduce(function(a, b) {
  return(bind_rows(a, b))
}, liste[1:24])

write.xlsx(res, "scimagojr.xlsx", sheetName = "All",
           col.names = TRUE, row.names = FALSE, append = FALSE)
write.csv(res, "scimagojr.csv", row.names = FALSE)
