# Librerias ---------------------------------------------------------------
library(tidyverse)
library(httr)

# Código ------------------------------------------------------------------

# Tutoriales httr
# Código de Francisca Muñoz https://github.com/francisca-imn/
# ChatGTP 5.0 apoyo en orden de código

# Crear funcion -----------------------------------------------------------

descargar_temp_meteochile <- function(estacion, anio) {
  # carpeta de destino
  destino <- paste0("scr/datos/datos_temp_", estacion, "_", anio)
  dir.create(destino, showWarnings = FALSE, recursive = TRUE)

  # meses con dos dígitos
  meses <- sprintf("%02d", 1:12)

  # loop meses
  for (mes in meses) {
    nombre <- sprintf("%s_%s%s_Temperatura", estacion, anio, mes)
    url    <- sprintf("https://climatologia.meteochile.gob.cl/application/datos/getDatosEma/%s/%s.csv.zip",
                      estacion, nombre)
    archivo <- file.path(destino, paste0(nombre, ".zip"))

    # descargar sin mensajes
    GET(url, write_disk(archivo, overwrite = TRUE), timeout(60))
  }
}

# Ejemplo: estación 200006, año 2023
descargar_temp_meteochile("200006", 2022)

