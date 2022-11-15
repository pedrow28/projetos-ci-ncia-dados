library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(openxlsx)


# Fontes ------------------------------------------------------------------

url_base_monitoramento <- "https://drive.google.com/drive/folders/1Wymwxghju1j0eeVEvEyyG_RDu3vEnVpm"

url_almg <- "https://www.almg.gov.br/acompanhe/planejamento_orcamento_publicom"

url_transparencia <- "https://www.transparencia.mg.gov.br/despesa-estado/despesa/despesa-resultado-pesquisa-avancada/2022/01-01-2022/31-12-2022/0/0/0/0/0/0/0/0/0/0/0/0/1/1/1/1/1/1/1/1/1/1/1/1/1/0"

url_github_painel <- "https://github.com/pedrow28/projetos-ciencia-dados/tree/main/painel_orcamentario"

url_shiny_web <- "https://shiny.rstudio.com/"

url_R <- "https://www.r-project.org/"

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


# 1. Header ------------------------------------------------------------------

header <- 
  dashboardHeader(
    title = "Painel Orçamentário"
  )

# 2. Sidebar -----------------------------------------------------------------

siderbar <- 
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      id = 'sidebar',
      menuItem("Introdução",
               menuSubItem("Objetivos deste painel", tabName = "introducao")),
      menuItem("Instrumentos orçamentarios", tabname = "instrumento_orcamento",
               menuSubItem("PPA", tabName = "ppa"),
               menuSubItem("LDO", tabName = "ldo"),
               menuSubItem("LOA", tabName = "loa")),
      menuItem("Monitoramento Orçamento", tabName = "monitoramento",
               menuSubItem("Programas de Governo", tabName = "monitoramento_programa"),
               menuSubItem("Órgãos", tabName = "orgaos")),
      menuItem("Fontes e contato", 
               menuSubItem("Fontes", tabName = "fontes"),
               menuSubItem("Contato", tabName = "contatos"))
      
    )
  )



# 3. Body --------------------------------------------------------------------

body <- dashboardBody(
  tabItems(
    
  ## 3.1 Introducao ----------------------------------------------------------
    
    tabItem(tabName = "introducao",
            tags$h1("Objetivos deste painel"),
            tags$div(
              tags$p("O presente painel tem os seguintes objetivos:"),
              tags$ol(
                tags$li("Introduzir os principais conceitos de como é estruturado o orçamento público."),
                tags$li("Esclarecer a estrutura do orçamento público do Estado de Minas Gerais, para o ano de 2002, visando dar transparência e aplicar os conceitos teóricos apresentados.")
              )
            ),
            tags$h1("Estrutura"),
            tags$div(
              "Visando estes objetivos, o painel foi estrutrado da seguinte forma:",
              tags$ul(
                tags$li(tags$b("Seção de instrumentos orçamentários:"),
                        tags$p("Seção com informações sobre o que são e como funcionam os principais instrumentos orçamentário - o Plano
                               Plurianual (PPA), a Lei de Diretrizes Orçamentárias (LDO) e a Lei Orçamentária Anual. Para cada instrumento,
                               é feito um paralelo com o orçamento do Estado de Minas Gerais, buscando elucidar na prática como esses dispositivos
                               funcionam e se complementam.")),
                tags$li(tags$b("Seção de Monitoramento Orçamentário:"),
                        tags$p("Seção com informações sobre o orçamento público mineiro de 2022, com dados organizados tanto pelos programas
                               de governo como por órgãos.")),
                tags$li(tags$b("Fontes e contato:"),
                        tags$p("Seção com as referências utilizadas para elaboração do painel como de contato com o autor.")),
                
              )
            )),
    
  ## 3.2 Instrumentos Orçamentos ------------------------------------------
  
    tabItem(tabName = "instrumento_orcamento"),
  
  ### 3.2.1 PPA ----------------------------------------------------------
  
    tabItem(tabName = "ppa",
            tags$h1("Plano Plurianual - PPA"),
            
            tags$h2("Programas do Planejamento do Estado de Minas Gerais (PPAG 2020-2023)"),
            
            tags$h3("Por Área Temática"),
            
            plotOutput('programa_area'),
            
            tags$h3("Por Órgão"),
            
            DTOutput('programa_orgao'),
            
            tags$h3("Lista completa de programas"),
            
            selectInput(inputId = "orgao_programa",
                        label = "Escolha um órgão",
                        choices = lista_selecao_orgaos),
            
            selectInput(inputId = "area_programa",
                        label = "Escolha uma área",
                        choices = lista_selecao_areas),
            
            
            DTOutput('view_programas'),
            ## Download data
            downloadButton("download_programas", "Download")
            
            
            ),
  
  
  
  
  
  ### 3.2.2 LDO ----------------------------------------------------------
  
    tabItem(tabName = "ldo",
            "Texto sobre a LDO"),
  
  ### 3.2.3 LOA ----------------------------------------------------------
  
  tabItem(tabName = "loa",
          tags$h1("Lei Orçamentária Anual - LOA"),
          tags$h2("O orçamento do governo mineiro em 2022"),
          tags$h3("Orçamento por programas"),
          tags$h3("Orçamento por órgãos"),
          tags$h3("Orçamento por área temática"),),
  
  ## Colocar orçamento por pasta e por area tematica
  
  ## 3.3 Monitoramento Orçamentario  ------------------------------------------
    tabItem(tabName = "monitoramento"),
  

  ### 3.3.1 Monitoramento por programa ----------------------------------------

    tabItem(tabName = "monitoramento_programa"),
  
  ### 3.3.2 Monitoramento por orgao ----------------------------------------
  
    tabItem(tabName = "orgaos"),
  

  ## 3.4 Fontes e contato --------------------------------------------------------
    
    tabItem(tabName = "fontes",
          ## Informações dos programas
          tags$h1("Fontes"),
          
          tags$div(
            tags$p("As informações dos Programas e Ações podem ser encontradas na",
                   tags$a(href = url_base_monitoramento," Base de Dados de Monitoramento.")),
            tags$p("Os instrumentos orçamentários mineiros - PPAG, LDO e LOA - estão disponibilizados no",
                   tags$a(href = url_almg," site da Assembleia Legislativa de Minas Gerais.")),
            tags$p("O ",tags$a(href = url_transparencia, "site da Transparência do Governo de Minas Gerais")," disponibiliza as informações de execução da despesa.")
            
            )
           ),
  
    tabItem(tabName = "contatos",
            tags$h1("Contatos"),
            
            tags$div(
              tags$p("Encontrou algum bug no painel? Peço a gentileza de informar por meio do pedrowilliamrd@gmail.com!"),
              tags$p("Para os desenvolvedores ou demais interessados,",
                     tags$a(href = url_github_painel, "aqui está o código do painel"),
                     "- lembrando que este foi escrito no",
                     tags$a(href = url_R, "R"),
                     "como um",
                     tags$a(href = url_shiny_web, "ShinyApp.")
              
                   )
            
                    )
            
    )
  
    
  )
)



# UI ----------------------------------------------------------------------

ui <- 
  dashboardPage(header, siderbar, body)
  


