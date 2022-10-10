library(readxl)
library(dplyr)
library(readr)
data = read_excel("/Users/fxjollois/Downloads/pop-act2554-csp-cd-6814.xls", 
                  sheet = "DEP_1968", skip = 12,
                  col_types = "numeric") %>%
  slice(-1)
names(data) = str_replace_all(names(data), "\n", " ")
res = data %>% 
  select(-Département, -`Libellé de département`) %>% 
  group_by(Région) %>%
  summarise_all(sum)

regions = read_csv("/Users/fxjollois/Downloads/region2020.csv") %>%
  mutate(Région = as.integer(reg)) %>%
  filter(Région > 10)

final = regions %>% inner_join(res) %>%
  select(-cheflieu, -tncc, -ncc, -nccenr, -reg, -Région) %>%
  rename(Région = libelle)

write_csv(final, file = "regions-csp-1968.csv")  
