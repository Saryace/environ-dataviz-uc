# Librerias ---------------------------------------------------------------

library(tidyverse)
library(guaguas)

# https://intro2r.library.duke.edu/join.html

# Datos de guaguas --------------------------------------------------------

guaguas # 858.782 datos de nombres de bebés en Chile

starwars # Información de todos los personajes de la saga Star Wars

fav_starwars <- read_csv("scr/datos/StarWars.csv")

fav_starwars # Dataset modificado https://fivethirtyeight.com/features/americas-favorite-star-wars-movies-and-least-favorite-characters/

# encuesta sobre las peliculas y personajes favoritos de la saga
# dataset original: https://github.com/fivethirtyeight/data/blob/master/star-wars-survey/StarWars.csv

# Preguntas investigación -------------------------------------------------

# los nombres Luke, Leia, etc... se volvieron comunes en Chile despues de
# la fecha de la primera película?  Dato: 20 de marzo de 1978

# Revisemos los datos de guaguas ------------------------------------------

# Existen Lukes o Leias en Chile?

guaguas %>%
  filter(nombre == "Luke" | nombre == "Leia") %>% # esto es "Luke O Leia"
  group_by(nombre, anio) %>% # revisar agrupando de formas diferentes
  count()

# Más personajes: a veces es mejor usar vector

personajes_principales <- c("Luke", "Leia", "Han", "Anakin")

guaguas %>%
  filter(nombre %in% personajes_principales) %>% # los del vector
  group_by(nombre) %>%
  count()

# Revisemos los datos de la saga ------------------------------------------
# Nombre completo en lugar de nombre y apellido por columnas
# Para ver regexs: https://r4ds.hadley.nz/regexps.html

starwars_nombre <- starwars %>%
  separate_wider_delim(name, delim = " ", names = c("nombre", "apellido")) # ! ver error

starwars_nombre <- starwars %>%
  separate_wider_regex(
    name,
    patterns = c(
      nombre = "^[^\\s]+", # todo antes del primer espacio
      apellido  = "(?:\\s+.+)?" # el resto después no "capturado"
    )
  )

# Revisemos ahora nuevamente guaguas --------------------------------------

personajes_principales <- starwars_nombre %>% pull(nombre)

guaguas %>%
  filter(nombre %in% personajes_principales) %>% # los del vector
  group_by(nombre) %>%
  count()

# Son todos de las películas?

# Revisemos la encuesta ---------------------------------------------------
# Los niveles deseados son "Favorito", "Neutral", "No le gusta", "No sabe/no contesta")

# Paso 1: encontrar categorias
fav_starwars %>%
  pivot_longer(-1) %>% # pivoteo todo menos la columna 1
  distinct(value) %>% # valores unicos
  pull(value)  # vector

# Paso 2: Reclasificar
fav_niveles <- fav_starwars %>%
  mutate(across(
    -1,  # todo menos la primera
    ~ case_when(
      .x %in% c("Very favorably", "Somewhat favorably") ~ "Favorito",
      .x == "Neither favorably nor unfavorably (neutral)" ~ "Neutral",
      .x %in% c("Very unfavorably", "Somewhat unfavorably") ~ "No le gusta",
      .x == "Unfamiliar (N/A)" | is.na(.x) ~ "No sabe/no contesta",
      TRUE ~ "No sabe/no contesta"
    )))

favoritos <-
fav_niveles %>%
  pivot_longer(-1, names_to = "nombre", values_to = "opinion") %>%
  group_by(nombre) %>%
  summarise(
    favorito_n = sum(opinion == "Favorito", na.rm = TRUE),
    total = n(),
    favorito_pct = favorito_n / total * 100
  ) %>%
  arrange(desc(favorito_pct)) %>%
  separate_wider_regex(
    nombre,
    patterns = c(
      nombre = "^[^\\s]+", # todo antes del primer espacio
      apellido  = "(?:\\s+.+)?" # el resto después no "capturado"
    )
  )

