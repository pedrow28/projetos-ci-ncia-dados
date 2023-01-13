library(readr)
library(tidyverse)


gastos_cartao_corporativo <- read_delim("C:/Users/m753140/Repositório Projetos/projetos-ciencia-dados/gastos_cartao_corporativo/Planilha12003a2022.csv", 
                                        delim = ";", escape_double = FALSE, trim_ws = TRUE, locale = locale(encoding = "windows-1252"))





gastos_cartao_corporativo %>% pull(`SUBELEMENTO DE DESPESA`) %>% unique()



gastos_atualizado_indice <- read_csv("C:/Users/m753140/Repositório Projetos/projetos-ciencia-dados/gastos_cartao_corporativo/bq-results-20230113-144559-1673622253548.csv")

gastos_atualizado_indice %>% pull(subelemento_despesa) %>% unique()


##Limpando codigos



gastos_atualizado_indice <- gastos_atualizado_indice %>% mutate(subelemento_despesa = str_replace_all(.$subelemento_despesa, "Ç", "A")) %>% 
  mutate(subelemento_despesa = str_replace_all(.$subelemento_despesa, "€", "C")) %>% 
  mutate(subelemento_despesa = str_replace_all(.$subelemento_despesa, "Ö", "I")) %>% 
  mutate(subelemento_despesa = str_replace_all(.$subelemento_despesa, "µ", "A")) %>% 
  mutate(subelemento_despesa = str_replace_all(.$subelemento_despesa, "¶", "A")) %>% 
  mutate(subelemento_despesa = str_replace_all(.$subelemento_despesa, "å", "O")) %>% 
  mutate(subelemento_despesa = str_replace_all(.$subelemento_despesa, "à", "O"))




gastos_atualizado_indice %>% pull(subelemento_despesa) %>% unique()