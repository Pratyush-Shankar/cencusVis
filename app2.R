library(ggplot2)
library(shiny)
library(dplyr)

counties = reactive({
race = readRDS("CensusVis/counties.rds")

counties_map = map_data("county")

#In order to join both tables we need to make sure that we are combining them by both
#state and county as a unique identifier. So, we can combine region and subregion in 
#the same counties_map into a new variable called "name"

counties_map = counties_map %>%
  mutate(name = paste(region, subregion, sep = ","))

counties = left_join(counties_map, race, by = "name")
})
ggplot(counties, aes(x=long, y=lat, 
                     group = group, 
                     fill = white))+
  geom_polygon(color = "black") +
  scale_fill_gradient(low = "white", high = "red")


