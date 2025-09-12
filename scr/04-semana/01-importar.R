# Cargar librerías --------------------------------------------------------
library(tidyverse)
library(readxl)
library(janitor)

# Cargar datos ------------------------------------------------------------
# ejemplo
# https://covid19.soporta.cl/pages/descarga y modificados manualmente
# verlos antes de comenzar

datos_covid <- read_csv("scr/datos/ejemplo_coma_decimal.csv") # que paso?

datos_covid_ok <- read_csv2("scr/datos/ejemplo_coma_decimal.csv")

glimpse(datos_covid_ok)

config_local <- locale(decimal_mark = ",", encoding = "UTF-8")

datos_covid_encoding <- read_delim(
  "scr/datos/ejemplo_coma_decimal.csv",
  delim = ";",
  locale = config_local
)

# Importar directo desde la web -------------------------------------------

read_csv("https://opendata.arcgis.com/datasets/05cb8cd004ca41768307623d607e7334_0.csv")

