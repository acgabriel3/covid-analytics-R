
#***
#Model para index elastic de mapa de calor 
library(data.table)
library(elastic)

'%%' <- function(a,b) paste0(a,b)

dadosDf <- fread('dados/pontos_aleatorios_casos_df.csv')

conn <- connect(host = "localhost", port = 9200)

try(
  index_create(conn = conn, 'mapacalor')
)


mapping <- '
{
    "properties": {
      "nome_local" :{
        "type": "keyword"
      },
      "localizacao": {
        "type": "geo_point"
      },
      "casos_confirmados": {
        "type": "integer"
      },
      "casos_suspeitos": {
        "type": "integer"
      } 
    }
}
'

mapping_create(conn = conn, index = "mapacalor", body = mapping)

#-15.772422, -47.897586
#-15.771297, -47.901245

for(i in 28.990:nrow(dadosDf)) {
  
  content <- '
  {
    "localizacao": {
      "lat": ' %% dadosDf$y[i] %%',
      "lon": ' %% dadosDf$x[i] %% '
    },
    "nome_local":' %% dadosDf$id[i] %% ',
    "casos_confirmados": ' %% dadosDf$casos_confirmados[i] %% ',
    "casos_suspeitos": ' %% dadosDf$casos_suspeitos[i] %% '
  }
  
  '

  print(docs_create(conn = conn, index = "mapacalor", body = content, type = "_doc"))

}

