library(tidyverse)
library(geobr)
library(lubridate)
library(readxl)
library(zoo)

## Informacoes open dados do governo
data <- read.csv("https://aplicacoes.mds.gov.br/sagi/servicos/misocial/?fl=codigo_ibge,anomes_s,pab_qtd_fam_benef_i,pab_valor_pago_d,pab_valor_medio_d,pab_extraordinario_qtd_fam_i,pab_extraordinario_valor_pago_d,pab_extraordinario_valor_medio_d,pab_qtd_beneficios_primeira_infancia_i,pab_qtd_beneficios_comp_familiar_crianca_i,pab_qtd_beneficios_comp_familiar_adolescente_i,pab_qtd_beneficios_comp_familiar_jovem_i,pab_qtd_beneficios_comp_familiar_gestante_i,pab_qtd_beneficios_superacao_extr_pobreza_i,pab_qtd_beneficios_compensatorio_transitorio_i&fq=anomes_s:%20[202111%20TO%20*]&q=*:*&rows=100000&wt=csv") 

data_1 <- data %>% mutate(codigo_ibge = as.character(codigo_ibge))


codigos_munic <- read_excel("../auxilio_brasil/dados/RELATORIO_DTB_BRASIL_DISTRITO.xls") %>% 
  select(Nome_UF, UF, `Código Município Completo`, Nome_Município, `Região Geográfica Imediata`)


data_completa <- codigos_munic %>% 
  left_join(data_1, by = c("Região Geográfica Imediata" = "codigo_ibge")) %>% 
  mutate(ano = as.character(substr(anomes_s, 1, 4)),
         mes = as.character(substr(anomes_s, 5, 6))) %>% 
  mutate(ano_mes = paste(ano, mes, sep = "-")) %>% 
  mutate(ano_mes = zoo::as.yearmon(ano_mes)) %>% arrange(ano_mes)

data_completa %>% group_by(ano_mes) %>% 
  summarise(n_familias = sum(pab_qtd_fam_benef_i),
            valor_total = sum(pab_valor_pago_d),
            valor_medio = mean(pab_valor_medio_d)) %>% View() 
  filter(!is.na(n_familias)) %>% 
  ggplot(aes(x = ano_mes, y = pab_valor_pago_d)) +
  geom_line() +
  geom_point()
    
