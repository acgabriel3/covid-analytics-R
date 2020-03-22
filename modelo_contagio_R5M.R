#***
#primeiro modelo analitico R calculo de autovalor vertices rede geografica ---> Deve se manter atualizado
library(igraph)
library(data.table)

formulario <- fread("dados/MODELO CSV FORM - formulario.csv")
localizacao <- fread("dados/MODELO CSV FORM - localização.csv")
sampleRede <- fread("dados/Sample.csv")

#***
#MANEIRA DE CALCULAR
#desenvolver modelo pronto para calcular o contagio de um determinado ente na rede e nao de toda a rede.
#na verdade a melhor opcao eh atualizar cada ente por iteracao
#assim o modelo pode funcionar em tempo real, ou ser totalmente rodado novamente em um determinado periodo
#pensar na maneira de salvar registros

#***
#MANEIRA DE DAR PESOS A CADA ITERACAO, E NORMALIZACAO PARA CONTAGIO
#Ideia calcular o contagio para cada vertice de acordo com os atributos do formulario e da rede.
#Em meio a esse calculo, pode surgir o mapa de calor, de que maneira devemos enviar estes atributos a nuvem?


#***
#MANEIRA DE GERAR REDE FINAL EM EDGE LIST

#***
#MANEIRA DE EXIBIR E CONSTRUIR A REDE COM IGRAPH