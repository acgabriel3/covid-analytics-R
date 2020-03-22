#***
#Geracao de massa aleatoria de dados

library(rgdal)
library(sp)
library(data.table)

mapaDF <- readOGR("dados/DF", "53MUE250GC_SIR")
mapaPE <- readOGR("dados/PE", "26MUE250GC_SIR")


mapaDF <- SpatialPolygons(mapaDF@polygons[1])

pontos_aleatorios_df <- spsample(teste, n = 100000 ,type = "random")

pontos_aleatorios_df <- as.data.frame(pontos_aleatorio_df)

pontos_aleatorios_df$id <- 1:100000
pontos_aleatorios_df$casos_confirmados <- sample(1:200, 100000, replace = TRUE)
pontos_aleatorios_df$casos_suspeitos <- sample(1:800, 100000, replace = TRUE)

fwrite(pontos_aleatorios_df, "dados/pontos_aleatorios_casos_df.csv")

