#***
#primeiro modelo analitico R calculo de autovalor vertices rede geografica ---> Deve se manter atualizado
library(igraph)
library(data.table)
library(geosphere)
library(stringi)
library(scales)

formulario <- fread("dados/MODELO CSV FORM - formulario.csv")
localizacao <- fread("dados/MODELO CSV FORM - localização.csv")
sampleRede <- fread("dados/Sample.csv")
coordenadas_aleatorias_Df <- dadosDf <- fread('dados/pontos_aleatorios_casos_df.csv')
ubs <- fread("dados/ubs.csv", sep = "@")

ubs_df <- ubs[ubs$uf == "DF",]

aux <- substring(localizacao$NU_LONGITUDE, 1, 3)
aux2 <- substring(localizacao$NU_LONGITUDE, 4, 100)
localizacao$NU_LONGITUDE <- paste0(aux, '.', aux2)

aux <- substring(localizacao$NU_LATITUTE, 1, 3)
aux2 <- substring(localizacao$NU_LATITUTE, 4, 100)
localizacao$NU_LATITUTE <- paste0(aux, '.', aux2)

rm(aux, aux2)

#menoracuracia distHaversine

distm(c(coordenadas_aleatorias_Df$x[2], coordenadas_aleatorias_Df$y[2]), c(coordenadas_aleatorias_Df$x[2], coordenadas_aleatorias_Df$y[2]), fun = distVincentyEllipsoid)


distm(c(as.numeric(localizacao$NU_LONGITUDE[1]), 
        as.numeric(localizacao$NU_LATITUTE[1])), 
      c(as.numeric(localizacao$NU_LONGITUDE[2]), 
        as.numeric(localizacao$NU_LATITUTE[2])), fun = distVincentyEllipsoid)

#***
#funcao para determinar contatos

networkLP <- NULL
#Uma hora para rodar com essa dimensao de dados (ou melhora-se o script ou usa-se o banco de dados. O banco de dados eh uma otima opcao)
for(i in 1:nrow(coordenadas_aleatorias_Df)) {
  
  print(i)
 
  for(j in 1:nrow(ubs)) {
    
   
  
    distancia <- distm(c(as.numeric(coordenadas_aleatorias_Df$x[i]), 
                      as.numeric(coordenadas_aleatorias_Df$y[i])), 
                     c(as.numeric(ubs_df$long[j]), 
                      as.numeric(ubs_df$lat[j])), fun = distVincentyEllipsoid)
  
  
    if(is.na(distancia))
    break
       
  
    if(distancia < 30) {
    
    aux <- data.frame(pessoa = coordenadas_aleatorias_Df$id[i], local = ubs_df$no_fantasia[j], tempo = sample(localizacao$DH_LOCALIZACAO, 1))
    
    networkLP <- rbind(networkLP, aux)
    
    }
      
  }
   
}

#***
#MANEIRA DE CALCULAR
#desenvolver modelo pronto para calcular o contagio de um determinado ente na rede e nao de toda a rede.
#na verdade a melhor opcao eh atualizar cada ente por iteracao
#assim o modelo pode funcionar em tempo real, ou ser totalmente rodado novamente em um determinado periodo
#pensar na maneira de salvar registros

#OBS ---> Usando coordans aleatorias como pessoas e localizacao como locais, poderiamos ter um exemplo de eficiencia do algoritmo.

#Tenho a lista de ligacoes, como dar valor a essa ligacoes de acordo com determinados atributos dos vertices? 
#Contar os casos de maneira integral inicialmente pode ser a maneira mais facil, posteriormente isto poderia ser feito ao longo do tempo


#Para calcular todos os que tiveram muitos casos

atributos_pessoas <- data.frame(pessoas = as.character(formulario$NU_CPF),
                                confirmados = as.vector(c(rep(1, 3), rep(0, 28))),
                                suspeitos = as.vector(c(rep(0, 3), rep(1, 9), rep(0, 19))))


atributos_pessoas$contagio <- atributos_pessoas$confirmados + atributos_pessoas$suspeitos * 0.9

atributos_locais <- data.frame(local = ubs$no_fantasia[1:40],
                               peso = as.numeric(c(rep(1, 14), rep(0.3, 26))),
                               contagio = 0)

rede_aleatoria_real <- data.frame(pessoa = as.character(rep(as.character(formulario$NU_CPF), each = 5)), 
                                  local = as.character(ubs$no_fantasia[1:40][sample(1:40, 155, replace = TRUE)]), 
                                  data = formulario$DH_CADASTRO[sample(1:40,155, replace = TRUE)])

fwrite(rede_aleatoria_real[c(1,2)], "dados/edgelist.csv")

# rede_real_bipartida <- graph_from_edgelist(as.matrix(rede_aleatoria_real[,c(1,2)]), directed = FALSE) 
# 
# mapping <- bipartite_mapping(rede_real_bipartida)
# 
# V(rede_real_bipartida)$type <- mapping
# 
# ego(rede_real_bipartida, nodes = V(rede_real_bipartida)[as.vector(V(rede_real_bipartida)$type) == 1])
# 
# V(g2)$contagio[c(ego(g2[-1])] %>% sum()

contato_pessoa_local <- function(pessoas) {
  
  for(pessoa in pessoas_confirmadas) {
    
    locais_contato_pessoa <- rede_aleatoria_real$local[rede_aleatoria_real$pessoa == pessoa]

    for(local in locais_contato_pessoa) {
      
      atributos_locais$contagio[atributos_locais$local == local] <<- atributos_locais$contagio[atributos_locais$local == local] + atributos_pessoas$contagio[atributos_pessoas$pessoas == pessoa]
      
    }
    
  }
  
}

contatato_local_pessoa <- function(pessoas) {

  for(pessoa in pessoas) {
    
    locais_contato_pessoa <- rede_aleatoria_real$local[rede_aleatoria_real$pessoa == pessoa]
    
    for(local in locais_contato_pessoa) {
      
      atributos_pessoas$contagio[atributos_pessoas$pessoa == pessoa] <<- atributos_pessoas$contagio[atributos_pessoas$pessoa == pessoa] + 
        (atributos_locais$contagio[atributos_locais$local == local] * atributos_locais$peso[atributos_locais$local == local]) 
      
    }
    
  }  

}

for(pessoa in atributos_pessoas$pessoas[atributos_pessoas$contagio > 0]) {
  
  locais_contato_pessoa <- rede_aleatoria_real$local[rede_aleatoria_real$pessoa == pessoa]
  # print(locais_contato_pessoa)
  for(local in locais_contato_pessoa) {
    
    atributos_locais$contagio[atributos_locais$local == local] <- atributos_locais$contagio[atributos_locais$local == local] + atributos_pessoas$contagio[atributos_pessoas$pessoas == pessoa]
    
  }
  
}

pessoas_nao_confirmadas <- atributos_pessoas$pessoas[atributos_pessoas$contagio == 0]

for(pessoa in pessoas_nao_confirmadas) {
  
  locais_contato_pessoa <- rede_aleatoria_real$local[rede_aleatoria_real$pessoa == pessoa]
  
  for(local in locais_contato_pessoa) {
    
    atributos_pessoas$contagio[atributos_pessoas$pessoa == pessoa] <- atributos_pessoas$contagio[atributos_pessoas$pessoa == pessoa] + 
                                                                      atributos_locais$contagio[atributos_locais$local == local] * atributos_locais$peso[atributos_locais$local == local] 
  
  }
  
}

atributos_pessoas$contagio[atributos_pessoas$pessoa %in% pessoas_nao_confirmadas] <- rescale(atributos_pessoas$contagio[atributos_pessoas$pessoa %in% pessoas_nao_confirmadas]
                                                                                             , to = c(0, 0.89))




pessoas_nao_confirmadas <- atributos_pessoas$pessoas[atributos_pessoas$contagio == 0]
pessoas_confirmadas <- atributos_pessoas$pessoas[atributos_pessoas$contagio > 0]

contato_pessoa_local(pessoas = pessoas_confirmadas)
contatato_local_pessoa(pessoas = pessoas_nao_confirmadas)

fwrite(atributos_pessoas,"dados/atributos_pessoas_sem_normalizar.csv")
fwrite(atributos_pessoas,"dados/atributos_locais_sem_normalizar.csv")

atributos_pessoas$contagio[atributos_pessoas$pessoa %in% pessoas_nao_confirmadas] <- rescale(atributos_pessoas$contagio[atributos_pessoas$pessoa %in% pessoas_nao_confirmadas]
                                                                                             , to = c(0, 0.89))

atributos_locais$contagio <- rescale(atributos_locais$contagio)

fwrite(atributos_pessoas,"dados/atributos_pessoas_normalizados.csv")
fwrite(atributos_pessoas,"dados/atributos_locais_normalizados.csv")


#***
#MANEIRA DE DAR PESOS A CADA ITERACAO, E NORMALIZACAO PARA CONTAGIO
#Ideia calcular o contagio para cada vertice de acordo com os atributos do formulario e da rede.
#Em meio a esse calculo, pode surgir o mapa de calor, de que maneira devemos enviar estes atributos a nuvem?


#***
#MANEIRA DE GERAR REDE FINAL EM EDGE LIST

#***
#MANEIRA DE EXIBIR E CONSTRUIR A REDE COM IGRAPH