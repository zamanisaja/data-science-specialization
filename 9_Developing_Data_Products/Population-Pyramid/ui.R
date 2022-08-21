# Define UI for random distribution app ----
library(shiny)

source("app.R")
ui <- fluidPage(

    # App title ----
    titlePanel("Input"),

    # Sidebar layout with input and output definitions ----
    sidebarLayout(

        # Sidebar panel for inputs ----
        sidebarPanel(
            # Input: Select the region from this list
            selectInput(
                inputId = "region",
                label = "Region:",
                choices = regions,
                selected = "Middle East & North Africa"
            ),
            br(),

            # Input: Select a country from this region
            selectInput(
                inputId = "country",
                label = "Country:",
                choices = countries[["Middle East & North Africa"]],
                selected = "Iran, Islamic Rep.",
            ),
            br(),

            # Input: Slider for the year
            sliderInput(
                inputId = "year",
                label = "year",
                value = 2010,
                min = 2001,
                max = 2020,
                step = 1,
            )
        ),

        # Main panel for displaying outputs ----
        mainPanel(

            # Output: Tabset w/ plot, summary, and table ----
            tabsetPanel(
                type = "tabs",
                tabPanel("Plot", plotOutput("plot")),
                # tabPanel("Summary", verbatimTextOutput("summary")),
                # tabPanel("Table", tableOutput("table"))
            )
        )
    )
)