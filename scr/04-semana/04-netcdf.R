# Librerias importar desde otros formatos ---------------------------------
library(ggplot2)
library(ncdf4)
library(terra) # ggplot + ncdf4 + terra para netCDF

# Archivos netCDF ---------------------------------------------------------

# https://zenodo.org/records/10580094

# SWE: Snow Water Equivalent

# SCA: Área cubierta por nieve.

# 4 cuencas: Río Maipo y Aconcagua (Chile), Río Mendoza y Tunuyán (Argentina).

# 5 temporadas hidrológicas (01/04/2018 – 31/03/2023).

# SWE disponible como series temporales

# SCA se obtiene umbralizando píxeles con SWE > 0.

# Archivos mensuales en formato NetCDF, proyección EPSG:32719 (WGS 84 / UTM).

# Resolución espacial de 50 m y mapas diarios.

# Cargar datos ------------------------------------------------------------

netcdf_nieve <- rast("scr/datos/andes_201804_eurac.nc") # abril 2018

intervalos <- terra::time(netcdf_nieve) # datos diarios

# Plot --------------------------------------------------------------------

# Con R base (sencillo)

plot(netcdf_nieve)

# Funciones terra ---------------------------------------------------------
# [fila , columna] [1 , 1] = primera fila, primera columa

# SWE promedio
swe_promedio <- global(netcdf_nieve, fun = mean, na.rm = TRUE)

swe_promedio <- global(netcdf_nieve, fun = mean, na.rm = TRUE)[,1] # solo mean

# SCA fracción por capa (con umbral >0)
sca_promedio <- global(netcdf_nieve > 0, fun = mean, na.rm = TRUE)[,1]

# Da cero? porqué?

# Carguemos 04 y 07 -------------------------------------------------------
# funcion list.files
archivos_nc <- list.files(
  path = "scr/datos",      # carpeta
  pattern = "\\.nc$",  # regex: termina en .nc, expresiones regulares!
  full.names = TRUE
)

# Promedios SWE y SCA -----------------------------------------------------

prom_swe_sca <- purrr::map_dfr(archivos_nc, ~{
  netcdf_nieve <- rast(.x)
  intervalos <- terra::time(netcdf_nieve)
  tibble(
    fecha     = as.Date(intervalos),
    swe_promedio = as.numeric(terra::global(netcdf_nieve,      mean, na.rm = TRUE)[1, ]),
    sca_promedio = as.numeric(terra::global(netcdf_nieve > 0,  mean, na.rm = TRUE)[1, ]),
    origen  = basename(.x) #nombre archivos
  )
})


# tibble ejemplo ----------------------------------------------------------

mascotas <- tibble(
  nombre_mascota = c("Cielo", "Mili", "Bunuelo"),
  edad_anio = c(11, 6, 0.6)
)



