# Cargar ggplot -----------------------------------------------------------

library(ggplot2) #se carga junto a tidyverse

# funcion ggplot en general -----------------------------------------------

# ggplot(mapping = aes(x = <VECTOR>, y = <VECTOR>)) +
#   geom_*()

# ggplot(data = tibble o dataframe,
#        mapping = aes(x = columna del eje x,
#                      y = columna del eje y)) +
# geom_*()

# Ejemplo rapido ----------------------------------------------------------

pp_mm <- c(1.5, 1.8, 2.2, 1.3, 1.7, 3.4, 4.0)

hr_perc <- c(90, 86, 90, 83, 94, 92, 99)

tipo <- c("A", "B", "A", "B", "B", "A", "B")

tipo_largo <- c("A", "B", "A", "B", "B", "A", "B", "C", "C")

# Vectores "sueltos" ------------------------------------------------------

ggplot(mapping = aes(x = pp_mm, y = hr_perc)) +
  geom_point()

pp_vs_hr_tb <- tibble(pp_mm = pp_mm,
                   hr_perc = hr_perc,
                   tipo = tipo) # similar data.frame

pp_vs_hr_df <- data.frame(pp_mm = pp_mm,
                   hr_perc = hr_perc,
                   tipo = tipo) # data.frame

# ejemplo tibble simetrico ------------------------------------------------

pp_vs_hr_error <- tibble(pp_mm = pp_mm,
                      hr_perc = hr_perc,
                      tipo = tipo_largo) # vector mas largo

pp_vs_hr_reciclaje <- tibble(pp_mm = pp_mm,
                         hr_perc = hr_perc,
                         tipo = "solo un tipo")

# Si no es explicito, siempre ocupa x e y ---------------------------------

ggplot(data = pp_vs_hr_reciclaje,
       mapping = aes(x = pp_mm, y = hr_perc)) +
  geom_point()

# errores iniciales ggplot ------------------------------------------------

ggplot(mapping = aes(x = pp_mm, y = hr_perc)) # falta +
geom_point()

ggplot(mapping = aes(x = pp_mm, y = hr_perc)) # mas tiene que ir aca
+ geom_point()

# los geom se pueden acumular ---------------------------------------------

ggplot(data = pp_vs_hr,
       mapping = aes(x = pp_mm, y = hr_perc)) +
  geom_point() +
  geom_vline(xintercept = 3) +
  geom_hline(yintercept = 85)

# el orden importa

# la funcion theme() controla la "decoracion" -----------------------------

ggplot(data = pp_vs_hr,
       mapping = aes(x = pp_mm, y = hr_perc)) +
  geom_point() +
  geom_hline(yintercept = 85) +
  geom_vline(xintercept = 3) +
  theme(text = element_text(size = 24)) # exagerado!

# Cada geom es distinto y tiene diferentes argumentos

ggplot(data = pp_vs_hr,
       mapping = aes(x = pp_mm, y = hr_perc)) +
  geom_bar() # veamos el error

ggplot(data = pp_vs_hr,
       mapping = aes(y = tipo)) +
  geom_bar() # hace un conteo

# comparemos geom_col vs geom_bar -----------------------------------------

ggplot(data = pp_vs_hr,
       mapping = aes(x = pp_mm, y = hr_perc)) +
  geom_col()

ggplot(data = pp_vs_hr,
       mapping = aes(x = tipo, y = hr_perc)) +
  geom_col()

?geom_col
