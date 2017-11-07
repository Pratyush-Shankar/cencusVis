library(shiny)
library(ggplot2)
library(dplyr)

ui = fluidPage(
  
  
titlePanel("USA Census Visualization",
           windowTitle = "CensusVis"),
sidebarLayout(
  sidebarPanel(
    helpText("Create demographic maps with Information from 2010 census"),
    
    selectInput(inputId = "var",
                label = "Choose a variable to display",
                choices = list("Percent White",
                               "Percent Hispanic",
                               "Percent Black",
                               "Percent Asian"),
                selected = "Percent White")
  ),
  mainPanel(
   # textOutput(outputId = "selected_var")
    plotOutput(outputId = "plot")
    
  )
)
  )

server = function(input, output){
  
  output$plot = renderPlot({
    
  counties = reactive({
    race = readRDS("counties.rds")
    
    counties_map = map_data("county")
    
    counties_map = counties_map %>%
      mutate(name = paste(region, subregion, sep = ","))
    
    left_join(counties_map, race, by = "name")
  })
  
  race = switch(input$var,
                "Percent White" = counties()$white,
                "Percent Hispanic" = counties()$hispanic,
                "Percent Black" = counties()$black,
                "Percent Asian" = counties()$asian
  )
  
  #output$selected_var = renderText(
  #  paste("You have selected: ", input$var))
  
  
    
  ggplot(counties(), aes(x=long, y=lat, 
                       group = group, 
                       fill = race))+
    geom_polygon(color = "black") +
    scale_fill_gradient(low = "white", high = "red")
})
}

shinyApp(ui,server)