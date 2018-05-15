require(R6)

#' RL environment "volcano explorer", which is one of the mountain car problem.
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format An \code{\link{R6Class}} generator object.
volcanoExplorer <-
  R6Class(classname = "Volcano Explorer",
          public = list(

            initialize = function(){
              private$x <- 1
              private$y <- 1
              private$vx <- 0
              private$vy <- 0
            },

            plot = function(...){
              image(1:nrow(private$environment), 1:ncol(private$environment),
                    private$environment, col=terrain.colors(50), axes=F, ann=F,...)
              points(private$x, private$y, pch=16, cex=1.5)
            },

            actionDiscrete = function(discrete.action, torque = 2){
              action.x <- 0
              action.y <- 0
              switch(as.character(discrete.action),
                     "0" = 0,
                     "1" = action.y <- torque,
                     "2" = action.y <- -torque,
                     "3" = action.x <- -torque,
                     "4" = action.x <- torque,
                     stop("discrete.action is required from {0, 1, 2, 3, 4}")
              )
              private$runEnvironment(action.x, action.y)
              return(self$getReward())
            },

            actionContinuous = function(action.x, action.y, torque = 2){
              private$runEnvironment(action.x*torque, action.y*torque)
              return(self$getReward())
            },

            observeDiscrete = function(){
              return(
                ceiling(private$x / private$state.roughness - 1) *
                  ceiling(ncol(private$environment) / private$state.roughness) +
                  ceiling(private$y / private$state.roughness)
              )
            },

            observeContinuous = function(){
              return(list(
                x = private$x,
                y = private$y,
                vx = private$vx,
                vy = private$vy
              ))
            },

            getReward = function(){
              state <- self$observeDiscrete()
              if(state==private$reward.state) return(private$reward.value)
              else return(0)
            }

          ),

          private = list(

            x = 1,
            y = 1,
            vx = 0,
            vy = 0,

            environment = volcano,
            reward.state = 222,
            reward.value = 10,

            state.roughness = 3,
            delta.t = 1,
            limit.velocity = 3,
            resistance.velocity = 0.7,
            gravity = 1,

            calcHeight = function(x=self$x, y=self$y){
              vo <- private$environment

              xl <- floor(x)
              xh <- ceiling(x)
              yl <- floor(y)
              yh <- ceiling(y)

              # Virtual Height
              #
              # xl_y = height(floor(x),y) = height descend to x
              # xh_y = height(ceiling(x),y) = height climb to x
              # x_yl = height(x,floor(y)) = height descend to y
              # x_yh = height(x,ceiling(y)) = height climb to y
              #
              vh <- list(
                x_yl = (xh-xl)*(x-xl)*(vo[xh,yl]-vo[xl,yl]) + vo[xl,yl],
                x_yh = (xh-xl)*(x-xl)*(vo[xh,yh]-vo[xl,yh]) + vo[xl,yh],
                xl_y = (yh-yl)*(y-yl)*(vo[xl,yh]-vo[xl,yl]) + vo[xl,yl],
                xh_y = (yh-yl)*(y-yl)*(vo[xh,yh]-vo[xh,yl]) + vo[xh,yl]
              )
              height <- (x-xl)*(vh$xh_y-vh$xl_y) + vh$xl_y

              return(list(
                z = height,
                z.descend.x = vh$xl_y,
                z.descend.y = vh$x_yl
              ))
            },

            calcTheta = function(x=self$x, y=self$y){
              # h <- private$calcHeight(x,y)
              h <- private$calcHeight(x,y)

              if(x == floor(x)) thetax <- 0
              else thetax <- atan((h$z - h$z.descend.x) / (x-floor(x)))

              if(y == floor(y)) thetay <- 0
              else thetay <- atan((h$z - h$z.descend.y) / (y-floor(y)))

              return(list(
                x = thetax,
                y = thetay
              ))
            },

            runEnvironment = function(action.x,action.y){
              # force
              theta <- private$calcTheta(private$x,private$y)

              fx <- action.x - private$gravity * sin(theta$x)
              fy <- action.y - private$gravity * sin(theta$y)

              # velocity
              vx <- (private$vx + fx * private$delta.t) * private$resistance.velocity
              vy <- (private$vy + fy * private$delta.t) * private$resistance.velocity

              vlim <- private$limit.velocity
              if (vx < -vlim) vx <- -vlim
              if (vx > vlim) vx <- vlim
              if (vy < -vlim) vy <- -vlim
              if (vy > vlim) vy <- vlim

              # position
              x <- private$x + vx * private$delta.t
              y <- private$y + vy * private$delta.t

              vo <- private$environment
              if (x < 1) x <- 1
              if (x > nrow(vo)) x <- nrow(vo)
              if (y < 1) y <- 1
              if (y > ncol(vo)) y <- ncol(vo)

              # update
              private$x <- x
              private$y <- y
              private$vx <- vx
              private$vy <- vy
            }

          ),
          active = list(
            xx = function(value){
              if (missing(value)) return(private$x)
              else print("sorry")
            }
          )
  )
