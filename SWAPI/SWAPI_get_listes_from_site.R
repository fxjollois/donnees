library(jsonlite)

liste_objets = fromJSON("https://swapi.dev/api/")

get_from_swapi = function(base_url) {
  retour = fromJSON(base_url, simplifyVector = FALSE)
  res = retour$results
  while (!is.null(retour$`next`)) {
    retour = fromJSON(retour$`next`, simplifyVector = FALSE)
    res = c(res, retour$results)
  }
  return (res)
}

for (o in names(liste_objets)) {
  res = get_from_swapi(liste_objets[[o]])
  for (r in 1:length(res)) {
    for (c in names(res[[r]])) {
      if (is.list(res[[r]][[c]]) & length(res[[r]][[c]]) == 0) {
        res[[r]][[c]] = NULL
      }
    }
    res[[r]]$created = NULL
    res[[r]]$edited = NULL
  }
  assign(o, res)
}

save(list = names(liste_objets), file = "SWAPI_listes.RData")

