
# Librerias ---------------------------------------------------------------
library(sf)
library(rnaturalearth)
library(viridis)
library(patchwork)
library(scales)
library(ggspatial)
library(tidyverse)
library(janitor)

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
          aes(fill = median_superficie_de_area_verde_por_habitante),
          color = "grey90") +
  scale_fill_viridis(begin = 0, end = 0.8)

# Ahora barras ------------------------------------------------------------

barras <- metro_areaverde %>%
  drop_na(median_superficie_de_area_verde_por_habitante) %>%
  ggplot(
    aes(x = fct_reorder(comuna,median_superficie_de_area_verde_por_habitante),
        y = median_superficie_de_area_verde_por_habitante,
        fill = median_superficie_de_area_verde_por_habitante)
  ) +
  geom_col() +
  labs(x = NULL, y = "Area verde por hab (nos se)") +
  scale_fill_viridis(begin = 0, end = 0.8) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

# Patchwork ---------------------------------------------------------------

mapa + barras + plot_layout(guides = "collect")
