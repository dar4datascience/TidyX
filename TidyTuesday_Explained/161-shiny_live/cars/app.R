library(shiny)
library(ggplot2)
library(bslib)

## base R!s
d <- mtcars
d$car_types <- rownames(d)
d <- d[,c("car_types","mpg", "cyl", "am", "disp", "wt")]
d$cyl <- as.factor(d$cyl)
d$am <- as.factor(d$am)

### UI
ui <- page_sidebar(
  theme = bs_theme(version = 5,
                   bootswatch = "cyborg"),
  
  title = "Cars!",
  
  sidebar = sidebar(
    
    title = "Filter controls",
    
    selectInput(inputId = "cyl",
                label = "Cylinders",
                choices = sort(unique(d$cyl)),
                selected = NULL,
                multiple = FALSE),
    
    selectInput(inputId = "am",
                label = "Transmission",
                choices = sort(unique(d$am)),
                selected = NULL,
                multiple = FALSE)
    
  ),
  
  mainPanel(tabsetPanel(
    type = "tabs",
    
    tabPanel("XY Plot", card(
      card_header("XY Plot"),
      plotOutput(outputId = "xy_plt"),
      full_screen = TRUE
    )),
    tabPanel("Histogram", card(
      card_header("Histogram"),
      plotOutput(outputId = "hist_plt"),
      full_screen = TRUE
    )),
    tabPanel("Table of Car Types", card(
      card_header("Table of Car Types"), 
      tableOutput(outputId = "tbl"),
      full_screen = TRUE
    ))
  ))
)



### Server
server <- function(input, output, session){
  
  ## update based on URL parameters
  observe({
    
    query <- parseQueryString(session$clientData$url_search)
    
    if(!is.null(query[['cyl']])){
      updateSelectInput(session, "cyl", selected = query[['cyl']])
    }
    
    if(!is.null(query[['am']])){
      updateSelectInput(session, "am", selected = query[["am"]])
    }
  })
  
  ## get data
  dat <- reactive({
    d[d$cyl == input$cyl & d$am == input$am, ]
  })
  
  ## xy plot
  output$xy_plt <- renderPlot({
    
    dat() |>
      ggplot(aes(x = disp, y = mpg)) +
      geom_jitter(size = 5,
                  color = "green") +
      geom_smooth(method = "lm",
                  se = FALSE,
                  color = "black",
                  size = 1.2) +
      theme_light()
    
  })
  
  ## hist plot
  output$hist_plt <- renderPlot({
    
    dat() |>
      ggplot(aes(x = "1", y = wt)) +
      geom_boxplot(color = "black",
                   fill = "light grey") +
      theme_light()
    
  })
  
  ## table of car types
  output$tbl <- renderTable({
    dat()[,"car_types"]
  })
}


## Shiny app must return a shinyapp
shinyApp(ui = ui, server = server)
