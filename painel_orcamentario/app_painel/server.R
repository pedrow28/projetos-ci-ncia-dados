#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(DT)

# Define server logic required to draw a histogram



# DADOS -------------------------------------------------------------------


programas <- openxlsx::read.xlsx("dados/programas_planejamento.xlsx")

lista_programas <- programas %>% select(Nome.do.Programa, Justificativa, Estratégia.de.Implementação, Unidade.Orçamentária.Responsável.pelo.Programa, Área.Temática) %>% 
  filter(!duplicated(Nome.do.Programa))


shinyServer(function(input, output, session) {
  
  

# Tabela programas por órgão ---------------------------------------------

  

  
    dados_orgao_programa <- lista_programas %>% group_by(Unidade.Orçamentária.Responsável.pelo.Programa) %>% 
      summarise(n = n()) %>% 
      select("Órgão" = Unidade.Orçamentária.Responsável.pelo.Programa, "Número de programas" = n) %>% 
      arrange(-`Número de programas`) %>% 
      datatable(rownames = FALSE)
  
    output$programa_orgao <- renderDT({
      
      dados_orgao_programa
  
      
    })
      
      

# Grafico programa area tematica ------------------------------------------

     dados_area_programa  <- lista_programas %>% group_by(Área.Temática) %>% 
       summarise(n = n()) %>% 
       select("Área" = Área.Temática, "Número de programas" = n)
     
     output$programa_area <- renderPlot({
       
       ggplot(data = dados_area_programa, aes(x = reorder(Área, `Número de programas`), y = `Número de programas`)) +
         geom_col(fill = "red") +
         geom_label(aes(label = `Número de programas`), fill = "#ff8080") +
         coord_flip() +
         theme_bw() +
         labs(x="", y="", title = "Número de programas do PPAG 2020-2023 por área temática") +
         theme(axis.text = element_text(face="bold"),
               axis.text.x = element_blank(),
               plot.background = element_blank(),
               panel.background = element_blank())
       
       
     }, bg = "transparent")
     
     
     

# Tabela todos os programas -----------------------------------------------


     ## Lista órgãos
     
     orgaos <- programas %>% pull(Unidade.Orçamentária.Responsável.pelo.Programa) %>% unique() %>% sort()
     
     # orgaos <- orgaos[3:141]
     
     lista_selecao_orgaos <- c("TODOS") %>% append(orgaos)
     
     
     
     ## Lista area tematica
     
     areas <- programas %>% pull(Área.Temática) %>% unique() %>% sort()
     
     
     lista_selecao_areas <- c("TODAS") %>% append(areas)
     
     
     ## Atualizando listas de escolhas dinamicamente
     
     
     
     # observe({
     #   if(input$orgao_programa != "TODOS")
     #     
     #     li
     #     
     #   
     #   updateSelectInput(session, "area_programa", choices = lista_dinamica_areas(), selected = "TODAS")
     #       
     #       
     # })
     
     
     programasInput <- reactive({
       
    
       rows <- (input$orgao_programa == "TODOS" | lista_programas$Unidade.Orçamentária.Responsável.pelo.Programa == input$orgao_programa) &
         (input$area_programa == "TODAS" | lista_programas$Área.Temática == input$area_programa)
       
       colnames(lista_programas) <- c("Programa", "Justificativa", "Estratégia de Implementação", "Órgão", "Área Temática")
       
       
       lista_programas[rows, , drop = FALSE] %>% datatable(rownames = FALSE)
       
       
       
     })
     
     
     output$view_programas <- renderDT({
       programasInput()
     })
      

    

})
