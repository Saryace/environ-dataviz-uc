
# Librerias ---------------------------------------------------------------
library(tidyverse)
library(palmerpenguins)

# Crear una funcion en R --------------------------------------------------

# Accion (nombre): multiplicar_por_10
# Argumento: x (debe ser un número)
# Cuerpo: operación x * 10
# Salida: el resultado de esa operación

multiplicar_por_10 <- function(x) {
  x * 10
}

multiplicar_por_10(3.5)

# Creo un vector ----------------------------------------------------------

vector <- 1:10 # operador : inicio:fin con enteros

# Creo una lista

lista <- list(numeros = 1:10)

lista_ejemplo <- list(numeros = as.numeric(1:10),
              letras = c("A", "B"))

# Usemos la funcion -------------------------------------------------------

multiplicar_por_10(vector) # 😮

# Existe una funcion llamada map que nos ayuda ----------------------------

purrr::map(vector, multiplicar_por_10) # 😔 una lista?

purrr::map_dbl(vector, multiplicar_por_10) # 🙂 funciona!

purrr::map(lista, multiplicar_por_10) # 🙂 funciona con listas!

# Funciones anónimas ------------------------------------------------------

# multiplicar por 10 tiene nombre

purrr::map_dbl(vector, ~ .x * 10)   # función anónima
# funcion map(vector, ~ cuerpo funcion con .x)

# ~ .x * 10  función anónima que toma un valor y lo multiplica por 10.
# .x representa los valores

# Porqué? -----------------------------------------------------------------
# Para avanzar en funcionalidades en R es útil saber listas
# por ejemplo, ggplot como objeto es una lista


# Plot --------------------------------------------------------------------

penguins %>%
  drop_na(species, bill_length_mm, bill_depth_mm) %>%
  filter(species == "Adelie") %>%
  ggplot(aes(bill_length_mm, bill_depth_mm)) +
  geom_point() +
  theme_bw()

# Quiero todas las especies (idea 1) --------------------------------------

penguins %>%
  drop_na(species, bill_length_mm, bill_depth_mm) %>%
  ggplot(aes(bill_length_mm, bill_depth_mm)) +
  geom_point() +
  facet_wrap(vars(species)) +
  theme_bw()

# Pero mis datos tienen 100 categorias! -----------------------------------

especies <- c("Adelie", "Chinstrap", "Gentoo") # podria ser mas

plots_por_especie <- map(especies, ~ {
  penguins %>%
    filter(species == .x, !is.na(bill_length_mm), !is.na(bill_depth_mm)) %>%
    ggplot(aes(x = bill_length_mm, y = bill_depth_mm)) +
    geom_point() +
    labs(x = "Bill length (mm)", y = "Bill depth (mm)", title = .x) +
    theme_bw()
})

# ejemplo: tercer elemento de la lista
plots_por_especie[[3]]



