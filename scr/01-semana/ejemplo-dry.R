# Instalar cowsay ---------------------------------------------------------

# install.packages("cowsay")

# Nombres clase  ----------------------------------------------------------

nombres_clase <- c("Lenna", "Pedro", "Golondrina")

animales <- c("ant", "longcat")

# Uso libreria cowsay -----------------------------------------------------

library(cowsay)

say(what = "texto aca", by = "alligator") # ver lista animales

say("hola", by = "ant") # argumentos de la funcion

# Interacion miau ---------------------------------------------------------

for (nombre in nombres_clase) {
  say(paste("hola", nombre), by = "cat")
}

# Funcion animal ----------------------------------------------------------
# funcion con dos argumentos, nombre y animal disponible en cowsay

saludo_animal <-
  function(nombre, animal) {
    say(paste("hola, ", nombre, "como estas?"), by = animal)
  }

# Funciona o no funciona? -------------------------------------------------

saludo_animal(
  nombre = "Sara",
  animal = "grumpycat"
)

saludo_animal(
  nombre = "Sara",
  animal = c("grumpycat", "longcat")
)

# Iteramos ----------------------------------------------------------------

for (nombre in nombres_clase) {
  for (animal in animales) {
    saludo_animal(nombre, animal)
  }
}
