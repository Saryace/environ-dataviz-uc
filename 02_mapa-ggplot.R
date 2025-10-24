
# Librerias ---------------------------------------------------------------
library(sf)
library(rnaturalearth)
library(viridis)
library(patchwork)
library(scales)
library(ggspatial)
library(tidyverse)
library(janitor)
library(patchwork)

# Metropolitana -----------------------------------------------------------

metropolitana <- st_read("scr/datos/metropolitana.geojson") # 52 comunas

area_verde <- read_csv("scr/datos/areaverde_por_habitante.csv") # 47 comunas

# Que muestra el glimpse? -------------------------------------------------

plot(metropolitana)

# Reparar nombres para join -----------------------------------------------

metro_areaverde <- metropolitana %>%
  clean_names() %>%
  mutate(comuna = tolower(comuna)) %>%
  left_join(area_verde %>%
              clean_names() %>%
              mutate(comuna = tolower(nombre_de_comuna)))

# Plot % area verde -------------------------------------------------------

mapa <- ggplot() +
  geom_sf(data = metro_areaverde,
          aes(color = median_superficie_de_area_verde_por_habitante,
              fill = median_superficie_de_area_verde_por_habitante))

# Ahora barras ------------------------------------------------------------

barras <- metro_areaverde %>%
  ggplot(
    aes(x = comuna,
        y = median_superficie_de_area_verde_por_habitante,
        color = median_superficie_de_area_verde_por_habitante,
        fill = median_superficie_de_area_verde_por_habitante)
  ) + geom_col()

# Patchwork ---------------------------------------------------------------

mapa + barras + plot_layout(guides = "collect")
