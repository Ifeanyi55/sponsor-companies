library(shiny)
library(shinyjs)
library(shinycssloaders)
library(shinythemes)
library(reactable)
library(reactablefmtr)


options(
  spinner.color = "#2F539B",
  spinner.color.background = "#FFFFFF",
  spinner.size = 2
)

# Define UI for application that hosts the list of
# companies that offer sponsorship jobs in the UK
ui <- fluidPage(
    theme = "newspaper",
    # Application title
    titlePanel(h3(strong("Updated Register of Worker & Temporary Worker Licensed Sponsors"),
                  style = "text-align:center;color:#2F539B;")),
    div(actionButton("button",strong("Information"),icon = icon("info")),
        style = "text-align:center;"),useShinyjs(),
    hidden(h4(id = "hidden","This table lists Worker and Temporary Worker sponsors. It includes information about the category of workers they’re licensed to sponsor and their sponsorship rating.",
              style = "text-align:center;color:#2F539B")),
    

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel = "",

        # Show a plot of the generated distribution
        mainPanel(
           align = "center",
           width = 12,
          withSpinner(reactableOutput("table"),type = 1)
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
    # toggle function
    observeEvent(input$button,{
      toggle("hidden")
    })
    
    # read data
    skilled_2023 <- read.csv("2023Skilled.csv")
    
    # delete rows 3 and 9
    skilled_2023 <- skilled_2023[-c(3,9),]
    
    # clean up column names
    colnames(skilled_2023)[c(1:5)] <- c("Companies","Town/City","County","Type & Rating","Route")
    
    # render table
    output$table <- renderReactable({
      skilled_table <- skilled_2023 |> 
        reactable(highlight = T,
                  searchable = T, 
                  filterable = T,
                  compact = T,
                  outlined = T,
                  bordered = T,
                  defaultColDef = colDef(
                    align = "center",
                    headerStyle = list(background = "#728FCE")
                  ),
                  theme = reactableTheme(
                    highlightColor = "#728FCE",
                    borderColor = "#728FCE",
                    borderWidth = 1
                    
                  ))
      
      skilled_table
      
    })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
