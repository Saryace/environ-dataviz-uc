# Instalar cowsay ---------------------------------------------------------

# install.packages("cowsay")

# Nombres clase  ----------------------------------------------------------

nombres_clase <- c("Lenna", "Pedro", "Golondrina")

animales <- c("ant", "longcat")

# Uso libreria cowsay -----------------------------------------------------

library(cowsay)

# Funcion animal ----------------------------------------------------------
# funcion con dos argumentos, nombre y animal disponible en cowsay

saludo_animal <-
  function(nombre, animal) {
    say(paste("hola, ", nombre, "como estas?"), by = animal)
  }

# Que pasa si el animal no existe? ----------------------------------------

saludo_animal(
  nombre = "Sara",
  animal = "random"
)

# Nueva funcion -----------------------------------------------------------

saludo_animal <- function(nombre, animal) {
  disponibles <- names(cowsay::animals)

  if (!animal %in% disponibles) {
    elegido <- sample(disponibles, 1)
    warning(
      sprintf(
        "OJO: el animal '%s' no existe. Se usará uno al azar: '%s'. Disponibles: %s",
        animal, elegido, paste(disponibles, collapse = ", ")
      ),
      call. = FALSE
    )
    animal <- elegido
  }

  cowsay::say(paste("hola,", nombre, "como estas?"), by = animal)
}

# Que pasa si el animal no existe? ----------------------------------------

saludo_animal(
  nombre = "Sara",
  animal = "osito"
)
