library(readxl)
library(stringr)
library(dplyr)
library(xlsx)
library(curl)

# Suppression des fichiers xlsx anciens donc
remove_old_files <- function() {
  fichiers_xlsx = dir(pattern = "*.xlsx")
  for (f in fichiers_xlsx)
    file.remove(f)
}

# Téléchargement de toutes les données jusqu'à l'année précédente
download_new_files <- function() {
  url_base = "https://www.scimagojr.com/countryrank.php?year=%i&out=xls"
  annee = as.numeric(substring(Sys.Date(), 1, 4)) - 1
  for (a in 1996:annee) {
    Sys.sleep(1)
    url_fichier = sprintf(url_base, a)
    fichier = sprintf("scimagojr_%i.xlsx", a)
    try(curl_download(url_fichier, fichier), silent = TRUE)
  }
}

# Compilation des fichiers en un seul 
compile_files <- function() {
  fichiers = dir(pattern = "scimagojr_[0-9]+.xlsx")
  
  liste = lapply(fichiers, function(f) {
    annee = str_extract(f, "[0-9]+")
    cat("Année : ", annee, "\n")
    test = cbind(Year = as.numeric(annee), read_excel(f))
    return(test)
  })
  
  res = Reduce(function(a, b) {
    return(bind_rows(a, b))
  }, liste)
  
  write.xlsx(res, "scimagojr.xlsx", sheetName = "All",
             col.names = TRUE, row.names = FALSE, append = FALSE)
  write.csv(res, "scimagojr.csv", row.names = FALSE)
  
  return(res)
}


remove_old_files()
download_new_files()
compile_files()


