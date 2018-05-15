server <- function(session, input, output) {
  rv <- reactiveValues(key = "nowhere",step = 0)
  rl <- reactiveValues(reward = 0,state = env$observeDiscrete())

  observeEvent(input$downButton, {rv$key <- "Down"; rv$step <- rv$step + 1})
  observeEvent(input$upButton, {rv$key <- "Up"; rv$step <- rv$step + 1})
  observeEvent(input$leftButton, {rv$key <- "Left"; rv$step <- rv$step + 1})
  observeEvent(input$rightButton, {rv$key <- "Right"; rv$step <- rv$step + 1})

  output$actlog <- renderText(paste("moved to",rv$key))
  output$plot <- renderPlot({
    action <- 0
    switch(rv$key,
           "Down" = action <- 2,
           "Up" = action <- 1,
           "Left" = action <- 3,
           "Right" = action <- 4
    )
    rl$reward <- env$actionDiscrete(action)
    rl$state <- env$observeDiscrete()
    env$plot()
    title(paste(rv$step,"step"))
  })
  output$reward <- renderText(paste("Reward:",rl$reward))
  output$state <- renderText(paste("State",rl$state))

}
