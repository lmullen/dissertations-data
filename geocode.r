# Geocode the universities
library(ggmap)
geocoded <- geocode(university_count$university)
university_count$lon <- geocoded$lon
university_count$lat <- geocoded$lat
university_count <- filter(university_count, !is.na(lon))
write.csv(university_count, "location/universities-geocoded-2.csv")
