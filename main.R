library(surveillance)

#Estrutura de interfaces, com code compilado em um soh script, permitindo que se adicionem novas analises rapidamente. 

#***
#Questoes acerca do que poderah ser realizado pelo proprio R
#Como acionar os scripts do R? O que o farah permanecer rodando? (poderia ser uma espécie de processamento em batch???)

#como identificar os casos suspeitos? E os riscos estatísticos?
#como acessar os históricos? 

#Básicos:
#-profundidade em passos de casos suspeitos, e envio de notificações. (R ou python)
#-Georreferenciamento de casos suspeitos (popular o elastic) (R ou python)
#-Casos que merecem visita para realização de testes (R ou python)
#-Previsão de possíveis surtos (inteligencia para buscas em clusters maiores) (R)
#-Monitoramento em tempo real para gerar notificações (pode ser em python)
#-Futuramente: TReinamento de algoritmos para previsão de surtos com base nos dados do SINAN ou CIESP, ou outras fontes. Exemplo:
  #-Ensinamos ao algoritmo que dada as configuracoes atuais da rede, e os dados epidemiológicos coletados, obtivemos tais resultados no SINAN.
  #-Com o o modelo pronto, dadas as configuracoes atuais da rede, e os dados epidemiológicos coletados no momento, o algoritmo nos diz quais
  #os provaveis numeros de casos nas regioes. 
  #-Informa-se aos gestores e hospitais, para que se preparem para um eventual aumento no numero de pacientes, e para que sejam tomadas medidas 
  #de quarentena. 
#-Pensar se uma eventual deteccao em tempo real de surtos eh viavel e util.

#Populando o elasticsearch:
#-Podem ser rotulados poligonos de regioes, de acordo com riscos, estes podem ser exibidos em cores nos mapas e em tempo real. 

#Quais dados eu irei receber referente a massa de dados???
#como seria um index no elasticsearch???
#Como o kibana poderia exibir os dados???