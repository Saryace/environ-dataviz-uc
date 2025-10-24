# Librerias ---------------------------------------------------------------

library(tidyverse)
library(guaguas)

# Datos -------------------------------------------------------------------

guaguas # 858.782 datos de nombres de bebés en Chile

starwars_nombre # desde dataset peliculas con personajes

favoritos # dataset ordenado por favoritismo de personajes

# Joins -------------------------------------------------------------------

favoritos %>%
  inner_join(starwars_nombre) # que paso?

# anti --------------------------------------------------------------------

anti_join(starwars_nombre, favoritos) # revisar

anti_join(favoritos, starwars_nombre) # revisaer diferencias

# left y right ------------------------------------------------------------

guaguas %>%
  left_join(favoritos) # que paso?

guaguas %>%
  right_join(favoritos) # mejor

guaguas %>%
  right_join(favoritos) %>%  # mejor
  arrange(desc(favorito_pct))

# Final plot --------------------------------------------------------------

guaguas %>%
  right_join(favoritos) %>%
  ggplot(aes(x = anio, y = n)) +
  geom_point() +
  facet_wrap(vars(nombre))

guaguas %>%
  right_join(favoritos) %>%
  drop_na() %>%
  ggplot(aes(x = anio, y = n)) +
  geom_point() +
  geom_vline(xintercept = 1978) +
  facet_wrap(vars(nombre)) # errores


