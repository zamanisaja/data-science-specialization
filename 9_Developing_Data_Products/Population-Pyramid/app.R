library(wbstats)
library(tidyverse)
library(ggplot2)
library(gganimate)
library(shiny)

# data --------------------------------------------
if (file.exists("data.csv")) {
    df <- read_csv2("data.csv", show_col_types = FALSE)
} else {
    wb_search("population ages.*male")[1:5, ]
    # array of ["SP.POP.0004.FE" .. "SP.POP.2024.MA" .. ]
    indicators <- paste(rep(
        c(
            "SP.POP.0004", "SP.POP.0509",
            paste("SP.POP.", 5 * c(2:15), 5 * c(2:15) + 4, sep = ""),
            "SP.POP.80UP"
        ), 2
    ), c(".FE", ".MA"), sep = "")

    # to get the orginal data I used this command
    df <- wb_data(indicator = indicators, start_date = 2001, end_date = 2020)
}

# To save the regions in the dataframe
df <- left_join(
    df,
    wb_countries()[, c("iso3c", "region")],
    by = c("iso3c")
)

# Remove unneccesary columns
df <- df %>%
    relocate(region, .after = "country") %>%
    select(-c("iso2c", "iso3c")) %>%
    rename(year = date)

# pivot date
df <- df %>%
    # look ath this example:
    # https://tidyr.tidyverse.org/reference/pivot_longer.html#ref-examples
    # making the table longer
    pivot_longer(
        cols = !c("country", "region", "year"),
        names_to = c("age", "gender"),
        names_pattern = "SP.POP.(.*).(..)",
        values_to = "population"
    ) %>%
    # making the gender as a factor
    mutate(gender = if_else(gender == "FE", "Female", "Male")) %>%
    mutate(gender = as.factor(gender)) %>%
    # making the age as a factor
    mutate(age = if_else(age == "80UP", "80+", age)) %>%
    mutate(age = paste(substr(age, 1, 2), "-", substr(age, 3, 4), sep = "")) %>%
    mutate(age = as.factor(age))


# regions and countries info
regions <- unique(df$region)
countries <- df %>%
    select(region, country) %>%
    group_by(region) %>%
    distinct()

countries <- countries %>%
    group_split(.keep = FALSE) %>%
    setNames((group_keys(countries))$region)

# plot generator
get_plot <- function(df, which_country = "Iran, Islamic Rep.", which_year = 2010) {
    total_population <- df %>%
        filter(country == which_country) %>%
        filter(year == which_year) %>%
        select(population) %>%
        summarise_all(sum)

    total_population <- round(total_population$population / 1000000, 0)

    g <- df %>%
        filter(country == which_country) %>%
        filter(year == which_year) %>%
        mutate(population = population / 1000) %>%
        mutate(population = ifelse(gender == "Male", population * (-1), population * 1)) %>%
        ggplot() +
        aes(x = age, y = population, fill = gender) +
        geom_bar(stat = "identity") +
        coord_flip() +
        labs(
            title = paste(
                "Population of", which_country,
                "(", which_year, ")",
                "[", total_population, " millions ]"
            ),
            x = "Age",
            y = "Population(in thousands)"
        ) +
        scale_y_continuous(labels = abs) +
        theme(
            legend.text = element_text(
                size = 15,
                face = "bold"
            ),
            plot.title = element_text(
                size = 22,
                hjust = 0.5,
                face = "bold"
            ),
            plot.subtitle = element_text(
                size = 14,
                hjust = 0.5,
                face = "bold"
            ),
            axis.title.x = element_text(
                size = 16,
                face = "bold"
            ),
            plot.caption = element_text(
                size = 12,
                hjust = 0.5,
                face = "italic",
                color = "gray"
            )
        )
    g
}