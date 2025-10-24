
# Librerias ---------------------------------------------------------------
library(sf)
library(rnaturalearth)
library(viridis)
library(patchwork)
library(scales)
library(ggspatial)
library(tidyverse)

# datos -------------------------------------------------------------------

chile <-
  ne_countries(scale = "medium",
               country = "Chile",
               returnclass = "sf")
climas_chile <-
  st_read("scr/datos/layer_koppen/layer_koppen_20220309023154.shp")

mapa_comunas <- chilemapas::mapa_comunas

# -------------------------------------------------------------------------

color_palette <- viridis(30)

c25 <- c(
  "dodgerblue2",
  "#E31A1C",
  "green4",
  "#6A3D9A",
  "#FF7F00",
  "black",
  "gold1",
  "skyblue2",
  "#FB9A99",
  "palegreen2",
  "#CAB2D6",
  "#FDBF6F",
  "gray70",
  "khaki2",
  "maroon",
  "orchid1",
  "deeppink1",
  "blue1",
  "steelblue4",
  "darkturquoise",
  "green1",
  "yellow4",
  "yellow3",
  "darkorange4",
  "brown"
)


mapa_clima <- ggplot() +
  geom_sf(data = chile) +
  geom_sf(data = climas_chile,
          alpha = 0.8,
          aes(color = KOPPEN_FIN, fill = KOPPEN_FIN)) +
  annotation_scale(location = "br", width_hint = 0.5) + # Scale bar
  annotation_north_arrow(location = "tl",
                         which_north = "true",
                         style = north_arrow_fancy_orienteering) +  # North arrow
  coord_sf(xlim = c(-78,-65), ylim = c(-58,-18)) +
  scale_x_continuous(breaks = seq(-78,-65, by = 5)) +
  scale_y_continuous(breaks = seq(-58,-18, by = 5)) +
  scale_color_manual(values = c25) +
  scale_fill_manual(values = c25) +
  labs(x = "",
       y = "",
       color = "",
       fill = "") +
  theme_bw() +
  theme(
    legend.position.inside = c(0.8, 0.40),
    legend.key.size = unit(0.3, "cm"),
    legend.text = element_text(size = 6),
    legend.spacing.y = unit(0.1, "cm")
  ) +
  guides(
    fill = guide_legend(ncol = 1),
    color = guide_legend(ncol = 1)
  )

