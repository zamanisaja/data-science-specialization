# Define server logic for random distribution app ----
server <- function(input, output, session) {
    observe({
        x <- input$region
        y <- c(countries[[x]]$country)

        # Can also set the label and select items
        updateSelectInput(
            session,
            inputId = "country",
            choices = y,
            selected = input$country
        )
        print(paste("Region :", x, ", Country: ", input$country, "(", input$year, ")"))
        output$plot <- renderPlot(get_plot(df, input$country, input$year))
    })
}

return(server)