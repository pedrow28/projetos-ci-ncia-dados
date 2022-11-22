library(shiny)
library(shinydashboard)
library(tidyverse)
library(plotly)
library(DT)
library(openxlsx)



# sourcing ----------------------------------------------------------------

# source("suporte_dados.R")

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
               menuSubItem("Objetivos deste painel", tabName = "introducao"),
               menuSubItem("Introdução ao Orçamento Público", tabName = "introducao_orcamento")),
      menuItem("Instrumentos orçamentarios", tabname = "instrumento_orcamento",
               menuSubItem("PPA", tabName = "ppa"),
               menuSubItem("LDO", tabName = "ldo"),
               menuSubItem("LOA", tabName = "loa"),
               menuSubItem("Pesquisa Dotações Orçamentárias"), tabName = "pesquisa_dotacoes"),
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
  

  ### 3.1.1 Objetivos ---------------------------------------------------------

  
    
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
  
  ### 3.1.1 Introdução Orçamento Público ---------------------------------------------------------
  
    tabItem(tabName = "introducao_orcamento",
            
            tags$h2("O que é o Orçamento Público?"),
            
            tags$div(
              tags$p("O orçamento público é o instrumento por meio do qual o governo define o total de recursos que necessita
                     para cumprir seus objetivos, fixando a forma como ele irá",
                     tags$b("arrecadar (receitas)"),
                     "e ",
                     tags$b("gastar (despesas)"), 
                     "tais recursos."),
              
              tags$p("Como tudo na administração pública, o orçamento público é normatizado por meio de legislação específica.
                     Sendo as mais importantes a ",
                     HTML(paste0(a(href = "https://www.planalto.gov.br/ccivil_03/LEIS/L4320.htm", "Lei nº 4.320/1964"))),
                     " que regulamenta ",
                     tags$b("como deve ser elaborado e controlado o orçamento público"),
                     "e o ",
                     HTML(paste0(a(href = "https://constituicao.stf.jus.br/dispositivo/cf-88-parte-1-titulo-6-capitulo-2-secao-2-artigo-165","Artigo 165 da Constituição Federal"))),
                     "que estabelecem os instrumentos orçamentários da administração pública."),
                   ),
            
            
            tags$h2("Os instrumentos do orçamento público"),
            
            tags$div(
              tags$p("Como dito na sessão anterior, a Constituição Federal estabelece os instrumentos utilizados pela
                     administração pública para planejamento, elaboração e execução do orçmaneto público. São eles:"),
              tags$ul(
                tags$li("O ", tags$b("Plano Plurianual - PPA"), " (no caso de Minas Gerais, o Plano Plurianual de Governo - PPAG)."),
                tags$li("A ",tags$b("Lei de Diretrizes Orçamentárias - LDO"), "."),
                tags$li("A ", tags$b("Lei Orçamentária Anual - LOA"), ".")
                    ),
              
              tags$p("A sessão 'Instrumentos Orçamentários' deste painel apresenta maiores explicações sobre cada um dos instrumentos.
                     De forma geral, os instrumentos funcionam e se complementam da seguinte maneira:"),
              tags$ol(
                tags$li(tags$b("O PPA é o planejamento de longo prazo."), "Visa estabelecer, no horizonte de 4 anos, ", 
                        tags$b("as diretrizes, objetivos e metas da administração pública"), "
                        e que, portanto nortearão a elaboração orçamentária. No PPA estão previstos os programas e objetivos estratégicos do governo."),
                tags$li(tags$b("O LDO é o manual de regras para elaboração do orçamento."), "Na lei, estão previstos os elementos 
                        que deverão ser levados em conta para elaboração do orçamento de fato, como as metas fiscais e de crescimento econômico
                        e a metodologia e premissas utilizadas para elaboração do orçamento."),
                tags$li(tags$b("A LOA é o orçamento de fato."), "Na LOA está toda a receita e despesa que o governo planeja para o ano (exercício financeiro).
                        É na LOA que podemos ver quando o governo planeja arrecadar com cada imposto ou gastar com cada secretaria, por exemplo.")
                
              )
                   ),
            
            tags$h2("Algumas curiosidades"),
            
            tags$div(
              tags$ul(
                tags$li("Os instrumentos orçamentários são elaborados e aprovados no ano anterior. Assim, no primeiro ano de cada gestão
                        o governo utiliza o orçamento elaborado pelo seu antecessor."),
                tags$li("O Estado de Minas Gerais possui, além dos intrumentos mencionados, o",
                        HTML(paste0(a(href="https://www.almg.gov.br/acompanhe/planejamento_orcamento_publico/pmdi/index.html",
                               "Plano Mineiro de Desenvolvimento Integrado"))),
                        "planejamento de horizonte temporal ainda maior que o previsto no PPA."),
                tags$li("Ainda sobre a administração pública mineira, o PPA mineiro é chamado Plano Plurianual de Governo - PPAG.")
              )
            ),
            
    ),
            
            
            
            
            
    
  ## 3.2 Instrumentos Orçamentos ------------------------------------------
  
    tabItem(tabName = "instrumento_orcamento"),
  
  ### 3.2.1 PPA ----------------------------------------------------------
  
    tabItem(tabName = "ppa",
            tags$h1("Plano Plurianual - PPA"),
            
            tags$h2("O que é o Plano Plurianual?"),
            
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
  
  ### 3.2.4 Ferramenta de consulta a Dotações Orçamentárias ----------------------
  
  tabItem(tabName = "pesquisa_dotacoes"),
  
  
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
  


