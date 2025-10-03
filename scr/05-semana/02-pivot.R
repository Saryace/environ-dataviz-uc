# Librerias ---------------------------------------------------------------
library(tidyverse)
library(palmerpenguins)
library(scales)

# Script basado en:
# https://carpentries-incubator.github.io/r-tidyverse-4-datasets/07-data-reshaping.html

# Miremos penguins --------------------------------------------------------

glimpse(penguins)

# Alargar -----------------------------------------------------------------

penguins %>%
  pivot_longer(contains("_"))

# Modificar nombres al mismo tiempo ---------------------------------------

penguins %>%
  pivot_longer(contains("_"),
               names_to = "variables",
               values_to = "valor")

# Más detalle! ------------------------------------------------------------

penguins %>%
  pivot_longer(contains("_"),
               names_to = c("cuerpo", "medida" , "unidad"),
               names_sep = "_")

# Hacer otras operaciones (ver documentacion) -----------------------------

penguins %>%
  pivot_longer(starts_with("bill"),
               values_drop_na = TRUE)

# Terminemos con un objecto -----------------------------------------------

pinguino_largo <- penguins %>%
  pivot_longer(contains("_"),
               names_to = c("cuerpo", "medida" , "unidad"),
               names_sep = "_",
               values_drop_na = TRUE)

pinguino_largo

# Trabajar a lo ancho -----------------------------------------------------

pinguino_largo_simple <- penguins %>%
  pivot_longer(contains("_"))

# Pivot Wider -------------------------------------------------------------

pinguino_largo_simple %>%
  pivot_wider(names_from = name,
              values_from = value)

# warning -----------------------------------------------------------------

# Warning message:
#   Values from `value` are not uniquely identified; output will contain list-cols.
# • Use `values_fn = list` to suppress this warning.
# • Use `values_fn = {summary_fun}` to summarise duplicates.
# • Use the following dplyr code to identify duplicates.
# {data} |>
#   dplyr::summarise(n = dplyr::n(), .by = c(species, island, sex, year, name)) |>
#   dplyr::filter(n > 1L)

# Qué paso? ---------------------------------------------------------------

# Los valores no están identificados de forma única; la salida contendrá
# columnas de lista. Se nos indica que el pivote más amplio no puede identificar
# de forma única las observaciones y, por lo tanto, no puede colocar un único
# valor en las columnas. Devuelve listas de valores.

# Falta columna <<<ID>>>

# Creamos otro long -------------------------------------------------------

pinguino_largo_simple <- penguins %>%
  mutate(id = row_number()) %>%
  pivot_longer(contains("_"))

pinguino_largo_simple

# Podemos hacer wide ------------------------------------------------------

pinguino_largo_simple %>%
  pivot_wider(names_from = "name",
              names_sep = "_",
              values_from = value)

# Uso wide: estadistica ---------------------------------------------------
# imaginar que empezamos con los datos a lo largo
# quiero hacer anova

pinguinos_sinna <- pinguino_largo_simple %>%
  pivot_wider(names_from = "name",
              names_sep = "_",
              values_from = value) %>%
  filter(!is.na(body_mass_g), !is.na(species))

# ANOVA -------------------------------------------------------------------

aov(body_mass_g ~ species, data = pinguinos_sinna)

# Alargar es útil para ggplot ---------------------------------------------

penguins %>%
  pivot_longer(contains("_")) |>
  ggplot(aes(y = value,
             x = species,
             fill = species)) +
  geom_boxplot() +
  facet_wrap(~name, scales = "free_y")


