require(shiny)
require(ggplot2)

shinyServer(function(input, output, session) {

  output$plot <- renderPlot({
 
    movies <- na.omit(movies)
    yMin <-min(movies$year)
    yMax <- max(movies$year)
    
    #budgetMax <- max(movies$budget)
    budgetMax <- 50000000

    genres <- input$genres

    action <- 99
    animation <- 99
    comedy <- 99
    drama <- 99
    documentary <- 99
    romance <- 99
    short <- 99

    if ("action" %in% genres) action <- 1
    if ("animation" %in% genres) animation <- 1
    if ("comedy" %in% genres) comedy <- 1
    if ("drama" %in% genres) drama <- 1
    if ("documentary" %in% genres) documentary <- 1
    if ("romance" %in% genres) romance <- 1
    if ("short" %in% genres) short <- 1
        
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

    xx=seq(yMin,yMax)
    xx2 <- sort(unique(dataset2$year))
    yy=rep(NA,length(xx))
    # mean movie budget per year
    for (i in 1:length(xx)) {
      ss <- subset(dataset2,dataset2$year==xx[i])
      yy[i] <- mean(ss$budget)
    }
    df <- data.frame(cbind(xx,yy))
    names(df) <- c('year','budget')
    
    p <- plot(budget ~ year, data=df, 
              xlim=c(1883 ,2005), ylim=c(0,budgetMax),
              xlab="Year", ylab="Budget ($)", 
              main="Mean Budget of Movies", col="darkgreen")
    print(p)

    if (length(xx2)>0) {
      fit <- lm(budget~poly(year,input$poly,raw=TRUE), data=df)
      lines(xx2,fit$fitted, col='darkblue',lwd=1.5)
    }

  }, height=450)

})
