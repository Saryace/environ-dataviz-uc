# Principios de Tufte
# Por encima de todo, muestra los datos.
# Maximiza la relación entre datos y tinta (1!)
# Elimina la tinta que no sea datos
# Elimina la tinta redundante
# Revisa y edita la tinta de datos

# https://jtr13.github.io/cc19/tuftes-principles-of-data-ink.html

# Voy a hacer un cambio para mostrar el control de version
# miau

# Librerias ---------------------------------------------------------------

library(tidyverse)
library(ggthemes)
library(ggExtra)
library(gghighlight) # final codigo

# Sobrio o simple  --------------------------------------------------------

yr <- 2010:2019
gdp <- c(50749.31, 51193.47, 51565.08, 52545.25, 53654.59, 54280.36, 55004.99, 56192.49, 57252.36, 57821.28)
df <- data.frame(yr, gdp)
ggplot(df, aes(yr,gdp)) +
  geom_line() +
  geom_point(size=1.5) +
  theme_minimal() +
  theme(axis.title=element_blank()) +
  scale_y_continuous(breaks=seq(50000,58000,1000),label=sprintf("$%s",seq(50000,58000,1000))) +
  scale_x_continuous(breaks=yr,label=yr) +
  annotate("text", x = 2019, y = 51500, adj=1,  family="serif",
           label = "US GDP per capita\nin constant dollars")


# Rangos adecuados --------------------------------------------------------

ggplot(mtcars, aes(disp, mpg)) +
  geom_point() +
  xlab("Displacement (cubic inch)") +
  ylab("Miles per gallon of fuel") +
  theme(axis.title.x = element_text(vjust = -0.5),
        axis.title.y = element_text(vjust = 1.5))

ggplot(mtcars, aes(disp, mpg)) +
  geom_point() +
  geom_rangeframe() +
  theme_tufte() +
  xlab("Displacement (cubic inch)") +
  ylab("Miles per gallon of fuel") +
  theme(axis.title.x = element_text(vjust = -0.5),
        axis.title.y = element_text(vjust = 1.5))

ggplot(mtcars, aes(disp, mpg)) +
  geom_point() +
  geom_rug() +
  theme_tufte(ticks = F) +
  xlab("Displacement (cubic inch)") +
  ylab("Miles per gallon of fuel") +
  theme(axis.title.x = element_text(vjust = -0.5),
        axis.title.y = element_text(vjust = 1))

# Cuando X e Y tienen distribuciones interesantes -------------------------

ggplot(quakes, aes(depth, mag)) +
  geom_point() +
  theme_tufte(ticks=F) +
  xlab("Depth (km)") +
  ylab("Richter Magnitude")

marginal <- ggplot(quakes, aes(depth, mag)) +
  geom_point() +
  theme_tufte(ticks=F) +
  xlab("Depth (km)") +
  ylab("Richter Magnitude")

ggMarginal(marginal, type = "histogram", fill="transparent")


# Destacar valores --------------------------------------------------------

url_crimen <- "https://gist.githubusercontent.com/GeekOnAcid/da022affd36310c96cd4/raw/9c2ac2b033979fcf14a8d9b2e3e390a4bcc6f0e3/us_nr_of_crimes_1960_2014.csv"

datos_crimen <- readr::read_csv(url_crimen, show_col_types = FALSE) %>%
  tidyr::pivot_longer(
    cols = -Year,
    names_to = "Crime.Type",
    values_to = "Crime.Rate"
  ) %>%
  mutate(Crime.Rate = round(Crime.Rate, 0))

# Min/Max/End per crime type ----------------------------------------------
min_crimen <- datos_crimen %>%
  group_by(Crime.Type) %>%
  slice_min(Crime.Rate, with_ties = FALSE) %>%
  ungroup()

max_crimen <- datos_crimen %>%
  group_by(Crime.Type) %>%
  slice_max(Crime.Rate, with_ties = FALSE) %>%
  ungroup()

fin_crimen <- datos_crimen %>%
  group_by(Crime.Type) %>%
  filter(Year == max(Year)) %>%
  ungroup()

# Plot ---------------------------------------------------------------------
ggplot(datos_crimen, aes(x = Year, y = Crime.Rate)) +
  facet_grid(Crime.Type ~ ., scales = "free_y") +
  geom_line(linewidth = 0.3) +
  geom_point(data = min_crimen, size = 1, colour = "red") +
  geom_point(data = max_crimen, size = 1, colour = "blue") +
  geom_point(data = fin_crimen, size = 0.5, colour = "black") +
  geom_text(data = min_crimen, aes(label = Crime.Rate), vjust = -1) +
  geom_text(data = max_crimen, aes(label = Crime.Rate), vjust =  2.5) +
  geom_text(data = fin_crimen, aes(label = Crime.Rate), hjust = 0, nudge_x = 1) +
  geom_text(data = fin_crimen, aes(label = Crime.Type), hjust = 0, nudge_x = 5) +
  expand_limits(x = max(datos_crimen$Year) + (0.25 * (max(datos_crimen$Year) - min(datos_crimen$Year)))) +
  scale_x_continuous(breaks = seq(1960, 2010, 10)) +
  scale_y_continuous(expand = c(0.1, 0)) +
  theme_tufte(base_size = 10, base_family = "Helvetica") +
  theme(
    axis.title  = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks  = element_blank(),
    strip.text  = element_blank()
  )


# gghighlight -------------------------------------------------------------

set.seed(1234)
d <- purrr::map_dfr(
  letters,
  ~ data.frame(
    idx = 1:400,
    value = cumsum(runif(400, -1, 1)),
    type = .,
    flag = sample(c(TRUE, FALSE), size = 400, replace = TRUE),
    stringsAsFactors = FALSE
  )
)

ggplot(d) +
  geom_line(aes(idx, value, colour = type))

d_limpio <- d %>%
  group_by(type) %>%
  filter(max(value) > 20) %>%
  ungroup()

ggplot(d_limpio) +
  geom_line(aes(idx, value, colour = type))

# Directo con gghighlight -------------------------------------------------

ggplot(d) +
  geom_line(aes(idx, value, colour = type)) +
  gghighlight(max(value) > 20)

