library(tidyverse)
library(plotly)
library(DT)
library(openxlsx)


# Dados -------------------------------------------------------------------

programas <- read.xlsx("dados/programas_planejamento.xlsx")

lista_programas <- programas %>% select(Nome.do.Programa, Justificativa, Estratégia.de.Implementação, Unidade.Orçamentária.Responsável.pelo.Programa, Área.Temática) %>% 
  filter(!duplicated(Nome.do.Programa))

dados_orgao_programa <- lista_programas %>% group_by(Unidade.Orçamentária.Responsável.pelo.Programa) %>% 
  summarise(n = n()) %>% 
  select("Órgão" = Unidade.Orçamentária.Responsável.pelo.Programa, "Número de programas" = n) %>% 
  arrange(-`Número de programas`) %>% 
  datatable(rownames = FALSE)

dados_area_programa  <- lista_programas %>% group_by(Área.Temática) %>% 
  summarise(n = n()) %>% 
  select("Área" = Área.Temática, "Número de programas" = n)


## Lista órgãos

orgaos <- programas %>% pull(Unidade.Orçamentária.Responsável.pelo.Programa) %>% unique() %>% sort()

# orgaos <- orgaos[3:141]

lista_selecao_orgaos <- c("TODOS") %>% append(orgaos)



## Lista area tematica

areas <- programas %>% pull(Área.Temática) %>% unique() %>% sort()


lista_selecao_areas <- c("TODAS") %>% append(areas)
