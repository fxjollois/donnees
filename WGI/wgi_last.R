library(readxl)
library(dplyr)
library(readr)
library(stringr)

year = str_sub(as.character(read_excel("wgidataset-2019.xlsx")[1,1]), -4)

wgi_last = Reduce(
  function(a, b) { return (a %>% full_join(b))}, 
  lapply(
    2:6, 
    function(i) {
      wgi = read_excel("wgidataset-2019.xlsx", sheet = i, skip = 15, col_names = FALSE, na = "#N/A")
      indicator = as.character(read_excel("wgidataset-2019.xlsx", sheet = i, col_names = FALSE, range = "A1"))
      country = wgi[,1]
      code = wgi[,2]
      values = wgi[,ncol(wgi)-5]
      df = country %>% bind_cols(code) %>% bind_cols(values)
      names(df) = c("Country", "Code", indicator)
      return(df)
    })
  )
wgi_last

write_csv(wgi_last, file = paste0("wgi", year, ".csv"))
