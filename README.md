# Resumo

O projeto estah estruturado para que seja possivel o reaproveitamento de código. A classe model visa
realizar a ligacao com os bancos de dados do projeto. A classe api, visa realizar a ligacao com as apis
do projeto. A qualquer momento é possível acrescentar ou retirar códigos na pasta, sem serem necessárias
grandes esforços estruturais para isso. 


# Como dispor os scripts

Cria uma pasta, e um script com o mesmo nome desta pasta. Dentro do script escreva:

interface(nomeInterface = "nome da pasta")

Caso seja a primeira pasta da sequencia, escreva:

source("interface_interpretada.r") (nesse caso também poderia ser a interface_compiladora)
interface(nomeInterface = "nome da pasta", caule = TRUE)

Todo script colocado dentro dessas pastas irá ser lido ao chamar o script com o nome da pasta, e 
caule = TRUE. Organize a modularidade de acordo com a profundidade das pastas (quanto mais profunda for
uma pasta, mais funcoes básicas e generalizaveis ela deve realizar).

Obs: Para que a interface encontre o modulo mais abaixo, é necessário adicionar uma nova pasta, e um 
novo script com o nome da pasta, com a função interface declarada, sem caule setado para TRUE.

# interface_interpretada

A função nesse script apenas adiciona toda a estrutura à memória

# interface_compiladora

A função nesse script adiciona toda a estrutra à memória, mas também gera um script com todo o código
presente nas pastas unificado em um só. A ideia é acelerar a interpretação do código, quando utilizado
em scripts que serão executados muitas vezes em um curto espaço de tempo.

Os códigos são guardados na pasta compilados, com o nome da interface caule, e a palavra chave "Comp"
ao final.

# Uso das bibliotecas

No script de execução (por exemplo realizando uma análise de surtos), escreva:
source("nome da interface caule.R")

E todas as funções na mesma estarão disponíveis. 

Favor leia manualmente os códigos gerados por interface compiladora, e guardados na pasta "compilados".

# Uso de prints

Não use prints em meio aos scripts estruturais, a interface compiladora não é capaz de lidar com eles