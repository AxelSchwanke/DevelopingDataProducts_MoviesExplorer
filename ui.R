require(shiny)
require(ggplot2)

dataset <- na.omit(movies)
yearMin <- 1900
yearMax <- max(movies$year)

rMin <- min(movies$rating)
rMax <- max(movies$rating)

lMin <- min(movies$length)
lMax <- 500
            
shinyUI(pageWithSidebar(
  headerPanel("Movies Explorer"),
  
  sidebarPanel(
    
    sliderInput(
      "years", label = "Release Date [Year]:",
      min = yearMin, max = yearMax, value = c(yearMin,yearMax), step = 1
    ),

    sliderInput(
      "lengths", label = "Movies Length [min]:",
      min = lMin, max = lMax, value = c(lMin,lMax), step = 1
    ),
    
    sliderInput(
      "ratings", label = "Rating [1=Low  10=High]:",
      min = rMin, max = rMax, value = c(rMin,rMax), step = 1
    ),
    
    checkboxGroupInput(
      "genres", "Genres:",
      c(
        "Action" = "action",
        "Animation" = "animation",
        "Comedy" = "comedy",
        "Drama" = "drama",
        "Documentary" = "documentary",
        "Romance" = "romance",
        "Short" = "short"
      ), selected = "action"
    ),
    
    sliderInput(
      "poly", "Degree of polynomial regression:",
      min = 1, max = 7, value = 3, step = 1
    )
    
  ),
  
  mainPanel(
    plotOutput('plot')
  )
))
