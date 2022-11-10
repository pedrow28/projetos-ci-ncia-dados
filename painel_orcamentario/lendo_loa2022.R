library(readxl)
library(tidyverse)


# Quadro de detalhamento de despesas com informações de crédito  --------

# É o documento que indica, para cada Unidade Orçamentária,
# a especificação dos elementos de despesa por programas, projetos, atividades e operações especiais.


qdd <- read_excel("dados/qdd_2022.xlsx")



# Informações de classificação orçamentária -------------------------------


dotacao <- read_excel("dados/classificacao_orcamentaria.xlsx")

tab <- dotacao %>% 
  separate(`Informações`, into = c("index", "info"), sep = ": ")

## Puxando as informacoes

lendo_planilha <- function(aba) {
  n_sheet <- as.character(aba)
  read_excel("dados/classificacao_orcamentaria.xlsx", sheet = n_sheet, skip = 2)
}

funcao <- read_excel("dados/classificacao_orcamentaria.xlsx", sheet = "1", skip = 2) %>% 
  select("Código Função" = CD_FUNCAO, "Denominação Função" = DENOMINACAO_FUNCAO)

subfuncao <- lendo_planilha(2) %>% 
  select("Código Subfunção" = CD_SUBFUNCAO, "Denominação Subfunção" = DENOMINACAO_SUBFUNCAO)

categoria_economica <- lendo_planilha(3) %>% select(2:4)

natureza_despesa <- lendo_planilha(4) %>% 
  select(-ANO_EXERCICIO)

modalidade_aplicacao <- lendo_planilha(5) %>% 
  select(-ANO_EXERCICIO)

fonte <- lendo_planilha(6) %>% 
  select(-ANO_EXERCICIO)

elemento_despesa <- lendo_planilha(7) %>% 
  select(-ANO_EXERCICIO)

item_despesa <- lendo_planilha(8)

discriminacao_naturezas_despesa <- lendo_planilha(9)

procedencia_uso <- lendo_planilha(10) %>% 
  select(-ANO_EXERCICIO)

acao_governamental <- lendo_planilha(11) %>% 
  select(-ANO_EXERCICIO)

codigo_orgao <- qdd %>% select(COD_ORGAO, ORGAO) %>% 
  filter(!duplicated(COD_ORGAO))

codigo_unidade_orcamentaria <- qdd %>% select(COD_UO, UO) %>% 
  filter(!duplicated(COD_UO))

programas <- qdd %>% select(PROGRAMA, NOME_PROGRAMA) %>% 
  filter(!duplicated(PROGRAMA))

acoes <- qdd %>% select(`AÇÃO`, `NOME_ACAO`) %>% 
  filter(!duplicated(NOME_ACAO))



# JOIN com QDD ------------------------------------------------------------

## conferencia com loa

qdd %>% group_by(FUNCAO, SUB_FUNCAO, NOME_PROGRAMA, NOME_ACAO, FONTE, IPU) %>% 
  summarise(valor_total = sum(`VALOR UO (R$)`)) %>% View()

















  
