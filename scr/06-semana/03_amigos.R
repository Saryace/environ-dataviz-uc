# Friends Don't Let Friends Make Bad Graphs
# https://github.com/cxli233/FriendsDontLetFriends

# Librerias ---------------------------------------------------------------
library(tidyverse)
library(palmerpenguins)

# Datos -------------------------------------------------------------------

pinguinos <- penguins %>%
  drop_na(body_mass_g, species)

# Promedios ---------------------------------------------------------------

# En este ejemplo, dos grupos de pinguinos tienen medias y se similares,
# pero distribuciones diferentes (Chistrap)
# No utilices gráficos de barras para separar medias.

pinguinos_promedio <- pinguinos %>%
  filter(
    species != "Chinstrap" |
      (species == "Chinstrap" & body_mass_g >= 3500 & body_mass_g <= 4500)
  )

ggplot(pinguinos_promedio, aes(x = species, y = body_mass_g)) +
  stat_summary(fun = mean, geom = "bar", fill = "grey70", color = "black") +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2) +
  labs(title = "bueno o malo?")

ggplot(pinguinos_promedio, aes(x = species, y = body_mass_g)) +
  geom_boxplot(outlier.shape = NA, fill = "lightblue") +
  geom_jitter(width = 0.2, alpha = 0.5, size = 1.5) +
  labs(title = "Boxplot + datos crudos (mejor!)",
       x = "Species", y = "Body mass (g)") +
  theme_minimal()

ggplot(pinguinos_promedio, aes(x = species, y = body_mass_g)) +
  stat_summary(fun = mean, geom = "point", size = 3, color = "red") +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2, color = "red") +
  geom_jitter(width = 0.2, alpha = 0.4) +
  labs(title = "promedio ± SE + datos")

# Muestras pequeñas (n bajo) ----------------------------------------------

# Las distribuciones y los cuartiles pueden variar mucho con un n pequeño,
# incluso si las observaciones subyacentes son similares.
# La distribución y los cuartiles solo tienen sentido con un n grande (sobre 50)

pinguino_n_bajo <- pinguinos %>%
  filter(species == "Adelie") %>%
  slice_sample(n = 12) %>%
  mutate(group = sprintf("Adelie (n=%s)", n()))

pinguino_n_alto <- pinguinos %>%
  filter(species == "Gentoo") %>%
  slice_sample(n = 100) %>%
  mutate(group = sprintf("Gentoo (n=%s)", n()))

ejemplo_n_pinguino <- bind_rows(pinguino_n_bajo, pinguino_n_alto)

ggplot(ejemplo_n_pinguino, aes(group, body_mass_g)) +
  stat_summary(fun = mean, geom = "bar", fill = "grey80", color = "grey30") +
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.15) +
  labs(title = "Ver plot en promedios",
       x = NULL, y = "Body mass (g)") +
  theme_minimal(base_size = 11)

# Colores uni vs bidireccionales ------------------------------------------

# Un error en la visualización de datos para mapas de calor/gradientes de color
# es cuando los colores más claros u oscuros son números arbitrarios.
# Es como que la barra más larga de un gráfico de barras no sea el valor más grande.

ggplot(pinguinos, aes(flipper_length_mm, body_mass_g)) +
  geom_point(aes(color = body_mass_g), alpha = 0.8, size = 2) +
  scale_color_gradient2(
    midpoint = mean(pinguinos$body_mass_g, na.rm = TRUE),
    low = "#2166ac",
    mid = "white",
    high = "#b2182b",
    name = "Body mass (g)"
  ) +
  labs(title = "Opiniones",
       x = "Flipper length (mm)", y = "Body mass (g)") +
  theme_minimal()

ggplot(pinguinos, aes(flipper_length_mm, body_mass_g)) +
  geom_point(aes(color = body_mass_g), alpha = 0.8, size = 2) +
  scale_color_viridis_c(name = "Body mass (g)") +
  labs(title = "Ok!",
       x = "Flipper length (mm)", y = "Body mass (g)") +
  theme_minimal()

pinguinos_z <- pinguinos %>%
  mutate(mass_z = as.numeric(scale(body_mass_g)))

ggplot(pinguinos_z, aes(flipper_length_mm, body_mass_g)) +
  geom_point(aes(color = mass_z), alpha = 0.8, size = 2) +
  scale_color_gradient2(low = "#2166ac", mid = "white", high = "#b2182b",
                        midpoint = 0, name = "Body mass (z)") +
  labs(title = "Escala centrada",
       x = "Flipper length (mm)", y = "Body mass (g)") +
  geom_hline(yintercept = mean(pinguinos$body_mass_g)) +
  theme_minimal()

