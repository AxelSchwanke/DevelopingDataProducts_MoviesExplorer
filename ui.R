require(shiny)
require(ggplot2)

dataset <- na.omit(movies)
yearMin <- min(movies$year)
yearMax <- max(movies$year)

rMin <- min(movies$rating)
rMax <- max(movies$rating)

lMin <- min(movies$length)
lMax <- max(movies$length)
lMax <- 500


shinyUI(pageWithSidebar(

  headerPanel("Movies Explorer"),

  sidebarPanel(
    
    sliderInput("years", "Release Date [Year]:",
                  min = yearMin, max = yearMax, 
                  value = c(yearMin,yearMax), 
                  step=1, format="####"),
    
    # The `format` argument to sliderInput is deprecated. 
    # Use `sep`, `pre`, and `post` instead. (Last used in version 0.10.2.2)
    

    sliderInput("lengths", "Movies Length [min]:",
                  min = lMin, max = lMax, 
                  value = c(lMin,lMax), step=1, format="####"),
                  
    sliderInput("ratings", "Rating [1=Low  10=High]:",
                  min = rMin, max = rMax, value = c(rMin,rMax) ),

    checkboxGroupInput("genres", "Genres:",
                       c("action" = "Action",
                         "animation" = "Animation",
                         "comedy" = "Comedy",
                         "drama" = "Drama",
                         "documentary", "Documentary",
                         "romance" = "Romance",
                         "short" = "Short"
                       ), selected="action"
                       ),
    
    sliderInput("poly", "Degree of polynomial regression:",
                  min = 1, max = 10, 
                  value = 1,
                  step=1)

  ),

  mainPanel(
    plotOutput('plot')
  )
))
