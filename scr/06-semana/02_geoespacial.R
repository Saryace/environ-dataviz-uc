library(sf)
library(tidyverse)
library(mapview)
library(leafsync)

# Con puntos desde csv ----------------------------------------------------

paradas <- read_csv("scr/datos/paradas_frecuentes.csv") %>%
  st_as_sf(coords = c("X", "Y"), crs = 32719)

mapview(paradas)

# Con datos vectoriales ---------------------------------------------------

ciclovias <- read_sf("scr/datos/ciclovias/ciclovias.shp")

mapview(ciclovias, color = "grey90")

# Con rasters -------------------------------------------------------------
library(raster)

temp_ene <- raster("scr/datos/temp_ene.tif")
temp_jul <- raster("scr/datos/temp_jul.tif")
region <- st_read("scr/datos/metropolitana.geojson")

p1 <- mapview(temp_ene, at = seq(-30, 50, 10), query.type = "click") +
  mapview(region, col.region = "transparent", alpha.region = 0)


p2 <- mapview(temp_jul, at = seq(-30, 50, 10), query.type = "click")+
  mapview(region, col.region = "transparent", alpha.region = 0)

sync(p1,p2)
