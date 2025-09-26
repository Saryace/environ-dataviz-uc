# Cargamos librerias ------------------------------------------------------

library(tidyverse)
library(broom)
library(glue)

# Datos anidados ----------------------------------------------------------

datos_pinguinos_anidados <-
  penguins %>%
  group_by(island,sex) %>%
  nest() %>%
  drop_na(sex)

# Creamos una funcion -----------------------------------------------------

lm_masa_aleta <- function(datos){
  lm(masa_corporal_g ~ largo_aleta_mm, data = datos)
}

# map(datos_pinguinos_anidados, lm_masa_aleta) ### error explosivo!

map(datos_pinguinos_anidados$data, lm_masa_aleta)

# Podemos trabajar en un esquema tidyverse --------------------------------

datos_pinguinos_anidados %>%
  mutate(modelos_lm = map(data, lm_masa_aleta))

# Usamos la funciones de broom para extraer coef --------------------------

datos_pinguinos_anidados %>%
  mutate(modelos_lm = map(data, lm_masa_aleta),
         tidy_lm = map(modelos_lm, tidy),
         glance_lm = map(modelos_lm, glance))

# Usamos la funcion unnest ------------------------------------------------

datos_modelos <-
  datos_pinguinos_anidados %>%
  mutate(modelos_lm = map(data, lm_masa_aleta),
         tidy_lm = map(modelos_lm, tidy),
         glance_lm = map(modelos_lm, glance)) %>%
  unnest(glance_lm)

# Hacemos un arreglo ------------------------------------------------------

datos_stat_limpios <- datos_modelos %>%
  mutate(
    r_cuadrado = signif(r.squared, 2),  # redondeo a dos sign.
    pval = signif(p.value, 2),#  redondeo a dos sign.
    etiqueta = glue("R² = {r_cuadrado}, p = {pval}") # redondeo a dos sign.
  ) %>%
  select(isla, sexo , etiqueta)

# Podemos usar los datos que extraimos antes en un ggplot -----------------

penguins %>%
  drop_na(sex) %>%
  ggplot(aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth(method = "lm") +
  geom_text(data = datos_stat_limpios,
            aes(
              x = 230, # posicion arbitraria
              y = 2900, # posicion arbitraria
              hjust = 1,
              label = etiqueta
            )) +
  facet_wrap(vars(island, sex)) + # no repetir plots, mejor facet
  theme_bw()

# Otra forma, crear funciones ggplot --------------------------------------

ggplot_funcion_corr = function(x, y) {
  ggplot(datos_pinguinos %>% drop_na(sexo), aes(x = .data[[x]], y = .data[[y]]) ) +
    geom_point() +
    geom_smooth(method = "lm", se = FALSE) +
    theme_bw()
}

ggplot_funcion_boxplot = function(x, y) {
  ggplot(datos_pinguinos %>% drop_na(sexo), aes(x = .data[[x]], y = .data[[y]]) ) +
    geom_boxplot() +
    theme_bw()
}

# La puedo aplicar a cualquier columna de datos_pinguinos -----------------

ggplot_funcion_corr(x = "flipper_length_mm", y = "body_mass_g")

ggplot_funcion_corr(x = "flipper_length_mm", y = "alto_pico_mm")

# Ahora para boxplot ------------------------------------------------------

ggplot_funcion_boxplot(x = "sexo", y = "body_mass_g")

ggplot_funcion_boxplot(x = "isla", y = "body_mass_g")


# Veamos por isla y sexo --------------------------------------------------

boxplots <- map(c("especie","isla","sexo"), #vector, .x en la funcion map
                ~ggplot_funcion_boxplot(.x, "body_mass_g")) #.f

boxplots[2] # son tres

# los nombres de archivo los definimos para guardar los datos

iwalk(boxplots, ~ ggsave(paste0("mis_ggplots/ggplot_", .y, ".png"),
                         plot = .x))
