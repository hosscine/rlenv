require(shiny)

ui <- pageWithSidebar(
  headerPanel("Reinforcement Learning Environment UI"),
  sidebarPanel(
    h5("下のボタンをクリックか方向キーで移動",align="center"),
    br(),
    tags$script('$(document).on("keydown",
                function (e) {
                if(e.which == 40) {
                Shiny.onInputChange("downButton", new Date());
                } else if (e.which == 38) {
                Shiny.onInputChange("upButton", new Date());
                } else if (e.which == 37) {
                Shiny.onInputChange("leftButton", new Date());
                } else if (e.which == 39) {
                Shiny.onInputChange("rightButton", new Date());
                }
                });
                '),
    actionButton("leftButton", "Left"),
    actionButton("rightButton", "Right"),
    actionButton("upButton", "Up"),
    actionButton("downButton", "Down"),
    br(),
    h3(textOutput("actlog"),align = "center"),
    # br(),
    h4(textOutput("reward")),
    # br(),
    h4(textOutput("state"))
  ),
  mainPanel(
    # htmlOutput("text"),
    plotOutput("plot")
  )
)
