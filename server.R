require(shiny)
require(ggplot2)

movies <- na.omit(movies)
yMin <- 1900
yMax <- max(movies$year)
ySeq <- seq(yMin,yMax)

#budgetMax <- max(movies$budget)
budgetMax <- 50000000

shinyServer(
  function(input, output, session) {
    # render* functions are reactive
    output$plot <- renderPlot({
      action <- animation <- comedy <- drama <- documentary <- romance <- short <- 99
      if ("action" %in% input$genres) action <- 1
      if ("animation" %in% input$genres) animation <- 1
      if ("comedy" %in% input$genres) comedy <- 1
      if ("drama" %in% input$genres) drama <- 1
      if ("documentary" %in% input$genres) documentary <- 1
      if ("romance" %in% input$genres) romance <- 1
      if ("short" %in% input$genres) short <- 1
        
      dataset2 <- subset(movies, 
        movies$year >= input$years[1] & 
        movies$year <= input$years[2] &  
        movies$length >= input$lengths[1] & 
        movies$length <= input$lengths[2] &  
        movies$rating >= input$ratings[1] &  
        movies$rating <= input$ratings[2] &
        (
          movies$Action == action |
          movies$Animation == animation |
          movies$Comedy == comedy |
          movies$Drama == drama |
          movies$Documentary == documentary |
          movies$Romance == romance |
          movies$Short == short 
        )
      )

      xx2 <- sort(unique(dataset2$year))
      yy <- rep(NA,length(ySeq))
    
      # mean movie budget per year (in million $)
      for (i in 1:length(ySeq)) {
        ss <- subset(dataset2,dataset2$year==ySeq[i])
       yy[i] <- mean(ss$budget)/1000000
      }
      budgetMax <- budgetMax / 1000000

      df <- data.frame(cbind(ySeq,yy))
      names(df) <- c('year','budget')
    
      plot(budget ~ year, data=df, 
           xlim=c(yMin ,yMax), ylim=c(0,budgetMax),
           xlab="Year", ylab="Budget [million $]", las=1,
           main="Mean Budget of Movies", pch=19, col="darkgreen")

      if (length(xx2)>0) {
        fit <- lm(budget~poly(year,input$poly,raw=TRUE), data=df)
       lines(xx2,fit$fitted, col='darkblue',lwd=1.8)
      }

    }, height=650)
  }
)
