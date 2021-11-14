library(tidyverse)
library(tidycensus)
library(leafleft)
library(tmap)

#Get the census variables

never <- paste0("B12002_", 104:110)
divorced <- paste0("B12002_18", 1:7)
cougars <- c(never, divorced)

# Fetch the data
philly_cougars <- get_acs(
  geography = "tract",
  variables = cougars,
  county = "Philadelphia",
  state = "PA",
  geometry = TRUE
)

# Add summary column

philly_cougars_fin <-
  philly_cougars %>% group_by(NAME) %>% summarise(total_cougars = sum(estimate))

# Create the map

tmap_mode("view")

coug <- tm_shape(philly_cougars_fin) +
  tm_basemap("Esri.WorldStreetMap") +
  tm_polygons(
    "total_cougars",
    title = "Total Cougars",
    id = "total_cougars",
    palette = "RdPu",
    alpha = .5,
    popup.vars = "NAME"
  ) + tm_layout(
    title = "Total Cougars (Unmarried or Divorced Women 45 and Older), 2019",
    legend.title.size = 1,
    legend.text.size = 0.6,
    legend.bg.color = "white",
    legend.bg.alpha = 1
  )

coug