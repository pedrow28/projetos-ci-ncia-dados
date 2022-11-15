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
library(openxlsx)

# Define server logic required to draw a histogram



# Servidor ----------------------------------------------------------------




shinyServer(function(input, output, session) {
  


# Tabela programas por órgão ---------------------------------------------

    output$programa_orgao <- renderDT({
      
      dados_orgao_programa
  
      
    })
      
      

# Grafico programa area tematica ------------------------------------------


     
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
      

      ## Download data
     
     output$download_programas <- downloadHandler(
       filename = "Lista Programas.csv",
       content = function(file) {
         write.csv(programasInput(), file, row.names = FALSE)
       }
     )
    

})
