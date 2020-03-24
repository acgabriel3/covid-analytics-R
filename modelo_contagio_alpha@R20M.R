reverse_edge <- function(g, e){
  #check_directed(g)
  g %>%
    get.edgelist %>%
    {.[e, ] <- c(.[e, 2], .[e, 1]); .} %>%
    graph.edgelist
}
normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

library(igraph); library(tidyverse); library("RColorBrewer")

#Lendo arquivos externos
s <- read.csv("dados/edgelist2.csv", sep = ";" , header=TRUE,
              colClasses=c("pessoa"="character"))
p <- read.csv("dados/confsus.csv", sep = ";" , header=TRUE, 
              colClasses=c("pessoas"="character"))
#Criando a rede de dois modos
g <- graph_from_edgelist(as.matrix(s))
bipartite.mapping(g) #Para checar apenas
V(g)$type <- ifelse(bipartite_mapping(g)$type, "local", "pessoa")
#Incluindo atributos externos
df <- igraph::as_data_frame(g, "both")
df$vertices <- df$vertices %>% 
  left_join(p, c('name'='pessoas'))
g <- graph_from_data_frame(df$edges,
                           directed = TRUE,
                           vertices = df$vertices)
V(g)$ConfSus[V(g)$type == "local"] <- 1
E(g)$id <- c(1:gsize(g))

#Invertendo o direcionamento da aresta com base no atributo Confirmado ou Suspeito
#Se confirmado ou suspeito mantém a direção. Caso contrário inverte a direção
temp <- reverse_edge(g, E(g)[from(V(g)$name[V(g)$ConfSus == 0])]$id)
V(temp)$type <- V(g)$type
V(temp)$ConfSus <- V(g)$ConfSus
E(temp)$id <- c(1:gsize(g2))
V(temp)$deg.out <- degree(g2, mode = "out")
g <- temp; rm(temp)

#Calculando alpha-centrality
V(g)$alpha <- alpha_centrality(g, nodes = V(g), alpha = 1, loops = FALSE,
                               exo = c(V(g)$ConfSus), weights = NULL, tol = 1e-07, sparse = TRUE)

#Normalizando. Locais, Pessoas sem Confirmação ou Suspeita, Pessoas com Confirmação ou suspeita
V(g)$contagio[V(g)$type == "local"] <- normalize(V(g)$alpha[V(g)$type == "local"])
V(g)$contagio[V(g)$type == "pessoa"] <- normalize(V(g)$alpha[V(g)$type == "pessoa"])
V(g)$contagio[V(g)$ConfSus == 10] <- 1
V(g)$contagio[V(g)$ConfSus == 5] <- 0.5

#Atributos do Grafo para visualização
pal1 <- heat.colors(10, alpha=1)
pal2 <- brewer.pal(9, "Blues")

V(g)$shape[(V(g)$type == "pessoa")] <- "circle"
V(g)$shape[(V(g)$type == "local")] <- "square"
V(g)$color[(V(g)$type == "pessoa")] <- pal1
V(g)$color[(V(g)$type == "local")] <- pal2
V(g)$label.color <- "black" 
V(g)$label.cex <- 1
V(g)$frame.color <-  "gray"
V(g)$size <- 18
plot(g, layout = layout_with_graphopt, edge.curved=.1, vertex.label=NA)

