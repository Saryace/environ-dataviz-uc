# Descargar datos en linea directo ----------------------------------------

# Tutorial: https://rpubs.com/cintia_rgz/783833

# Google Drive ------------------------------------------------------------

library(googledrive)
# drive_deauth() # asegurarnos que funcione el ejemplo
drive_auth() # se abre sesión

# Explorar ----------------------------------------------------------------

#Listado de elementos
directorio <- drive_ls()

# Veamos la lista de elementos
directorio$name

# Solo 10 pdfs
drive_find(type = "pdf", n_max = 10)

# Expresión regular que contenta en el nombre "Session"
drive_find(pattern = "\\bSession\\b")

# Descargar, subir, borrar (CUIDADO) --------------------------------------

drive_mkdir("carpeta_nueva_3")

drive_upload("scr/datos/ejemplo_coma_decimal.csv",
             path = '~/carpeta_nueva_3/',
             overwrite = TRUE)

# Dropbox -----------------------------------------------------------------

library(rdrop2)

drop_auth() # se abre sesión

#Listado del directorio
# directorio <- drop_dir()

# Veamos los contenidos del directorio
# directorio$name

# no uso dropbox 😔

# One drive ---------------------------------------------------------------

library(Microsoft365R)

mi_onedrive <- get_personal_onedrive()
