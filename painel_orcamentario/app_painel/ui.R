library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)


# Fontes ------------------------------------------------------------------

url_base_monitoramento <- "https://drive.google.com/drive/folders/1Wymwxghju1j0eeVEvEyyG_RDu3vEnVpm"

url_almg <- "https://www.almg.gov.br/acompanhe/planejamento_orcamento_publicom"

url_transparencia <- "https://www.transparencia.mg.gov.br/despesa-estado/despesa/despesa-resultado-pesquisa-avancada/2022/01-01-2022/31-12-2022/0/0/0/0/0/0/0/0/0/0/0/0/1/1/1/1/1/1/1/1/1/1/1/1/1/0"

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
               menuSubItem("Objetivos deste painel", tabName = "introducao"),
               menuSubItem("Fontes", tabName = "fontes")),
      menuItem("Instrumentos orçamentarios", tabname = "instrumento_orcamento",
               menuSubItem("PPA", tabName = "ppa"),
               menuSubItem("LDO", tabName = "ldo"),
               menuSubItem("LOA", tabName = "loa")),
      menuItem("Monitoramento Orçamento", tabName = "monitoramento",
               menuSubItem("Programas de Governo", tabName = "monitoramento_programa"),
               menuSubItem("Órgãos", tabName = "orgaos"))
      
    )
  )



# 3. Body --------------------------------------------------------------------

body <- dashboardBody(
  tabItems(
    
  ## 3.1 Introducao ----------------------------------------------------------
    
    tabItem(tabName = "introducao",
            "Texto da Introdução"),
  
    tabItem(tabName = "fontes",
            ## Informações dos programas
            tags$h1("Fontes"),
            tags$p("As informações dos Programas e Ações podem ser encontradas na",
                   tags$a(href = url_base_monitoramento," Base de Dados de Monitoramento.")),
            tags$p("Os instrumentos orçamentários mineiros - PPAG, LDO e LOA - estão disponibilizados no",
                   tags$a(href = url_almg," site da Assembleia Legislativa de Minas Gerais.")),
            tags$p("O ",tags$a(href = url_transparencia, "site da Transparência do Governo de Minas Gerais")," disponibiliza as informações de execução da despesa.")
            
            
            ),
    
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
            
            
            DTOutput('view_programas')),
  
  
  
  
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
  
    tabItem(tabName = "orgaos")
    
  )
)



# UI ----------------------------------------------------------------------

ui <- 
  dashboardPage(header, siderbar, body)
  


