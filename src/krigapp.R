library(shiny)
library(ggplot2)
library(rlibkriging)
library(shinythemes)

ui <- fluidPage(
  theme=shinytheme('slate'),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("kern", "Kernel", choices=list(Gaussian="gauss",Exponential="exp",Materntrois="matern3_2",Materncinq="matern5_2")),
      sliderInput(inputId='N',label='Number of data',value=5,min=2,max=10,step=1),
      selectInput("opt", "Optimisation method", choices=list(BFGS="BFGS",Newton="Newton",None="none")),
      conditionalPanel(
        condition = "input.Opt == 'none'",
        sliderInput(inputId='theta',label='Range',value=0.2,min=0,max=1,step=0.001),
        sliderInput(inputId='sig',label='Standard Variance',value=0.5,min=0,max=1,step=0.001)
      ),
      conditionalPanel(
        condition = "input.Opt != 'none'",
        sliderInput(inputId='thetaopt',label='Initial range',value=0.2,min=0,max=1,step=0.001),
        sliderInput(inputId='sigopt',label='Initial standard deviation',value=0.5,min=0,max=1,step=0.001),
        actionButton("bout", "Parameters estimation"),
        radioButtons("est", "Estimation method", list(LogLikelihood="LL",LeaveOneOut="LOO",LogMarginalPosterior="LMP")),
        
        conditionalPanel(
          condition = "input.est == 'LOO'",
          tags$div(checkboxInput("P1", "Nugget effect", value = FALSE), 
                   style = "pointer-events: none; opacity: 0.5;"),
          
        ),
        conditionalPanel(
          condition = "input.est != 'LOO'",
          checkboxInput("P", "Nugget effect", value = FALSE),
          conditionalPanel(
            condition = "input.P == true",
            sliderInput("par", "Nugget parameter", min = 0, max = 1, value = 0.5,step=0.001)
            ,
            actionButton("seed", "Change random seed"),
            
            
          )
          
        )

      )
    ),
    mainPanel(
      h1(titlePanel("Kriging")),
      textInput("fonc", "Function to interpolate : f(x)=", value = "1 - 1 / 2 * (sin(12 * x) / (1 + x) + 2 * cos(7 * x) * x^5 + 0.7)"),
      h4(textOutput("Noy")),
      column(6, actionButton("run2", "RUN"),),
      plotOutput("vec"),
      h3(textOutput("mod3")),
      h4(textOutput("mod2")),
      h4(textOutput("mod")),
      h5("Author : Moureaux Oscar"),

    )
  )
  
)
server=function(input,output,session){
  
  seedrec <- reactiveVal(1)
  
  observeEvent(input$seed, {
    seedrec(sample(1:100000, 1))
  })
  
  ################################################################
  ########INITIALISATION DES VARIABLES REACTIVES##################
  n=101
  x=as.matrix(seq(0, 1,, n))
  
  X <- reactive({
    as.matrix(seq(0, 1,, input$N))
  })
  
  
  parameters =reactive({
    list("sigma2" =input$sig, "theta" = matrix(c(input$theta), nrow = 1))
  })
  
  y <- reactive({
    ma_fonction()(X())
  })
  
  k_R <- reactive({
    
    Kriging(y(), X(),optim=input$opt,kernel = input$kern,parameters=parameters(),objective=input$est)
  })
  
  ynugg <- reactive({
    set.seed(seedrec())
    ma_fonction()(X()) + input$par/5 * rnorm(nrow(X()))
  })
  
  k_Rnugg <- reactive({
    set.seed(seedrec())
    
    NuggetKriging(ynugg(), X(),optim=input$opt,kernel=input$kern,parameters=parameters(),objective=input$est)
  })
  
  ma_fonction <- reactive({
    f <- input$fonc
    func <- eval(parse(text = paste0("function(x) {", f, "}")))
    return(func)
  })
  
  
  
  output$Noy=renderText({
    paste("Choosen Kernel :",input$kern)
  }) 
  
  kR0 <- reactive({
    set.seed(seedrec())
    Kriging(y(), X(),optim=input$opt,kernel = input$kern,objective=input$est)
  })
  
  kR0nugg <- reactive({
    set.seed(seedrec())
    NuggetKriging(ynugg(), X(),optim=input$opt,kernel = input$kern,objective=input$est)
    
  })
  
  
  ################################################################
  ########CHANGEMENT DES PARAMETRES SI APPUI DU BOUTON############
  
  observeEvent(input$bout, {
    if(input$P==FALSE) {
      updateSliderInput(session, "thetaopt", value = kR0()$theta()[1])
      updateSliderInput(session, "sigopt", value = kR0()$sigma2()[1])
    }
    if(input$P==TRUE) {
      updateSliderInput(session, "thetaopt", value = kR0nugg()$theta()[1])
      updateSliderInput(session, "sigopt", value = kR0nugg()$sigma2()[1])
    }
  })
  
  
  
  ################################################################
  ########################     PLOT      #########################
  
  output$vec <- renderPlot({
    input$bout
    input$seed
    input$run2
    isolate({
      
      if(input$P==FALSE) {
        set.seed(seedrec())
        
        p <- predict(k_R(), x, TRUE, FALSE)
        
        plot(ma_fonction())
        points(X(), y(),col="red")
        lines(x, p$mean, col = 'blue')
        polygon(c(x, rev(x)), c(p$mean - 2* p$stdev, rev(p$mean + 2 * p$stdev)), border = NA, col = rgb(0, 0, 1, 0.2))
        set.seed(seedrec())
        
        s <- simulate(k_R(), nsim = 10, seed = 123, x = x)
        matplot(x, s, col = rgb(0, 0, 1, 0.2), type = 'l', lty = 1, add = TRUE)
        
      } 
      
      if(input$P==TRUE) {
        set.seed(seedrec())
        
        p <- predict(k_Rnugg(), x, TRUE, FALSE)
        
        plot(ma_fonction())
        points(X(), ynugg(),col="red")
        lines(x, p$mean, col = 'blue')
        polygon(c(x, rev(x)), c(p$mean - 2* p$stdev, rev(p$mean + 2 * p$stdev)), border = NA, col = rgb(0, 0, 1, 0.2))
        set.seed(seedrec())
        
        s <- simulate(k_Rnugg(), nsim = 10, seed = 123, x = x)
        matplot(x, s, col = rgb(0, 0, 1, 0.2), type = 'l', lty = 1, add = TRUE)
        
      } 
    })
  })
  
  
  ################################################################
  ########AFFICHAGE DES PARAMETRES EN COURS############
  
  output$mod3 <- renderText({
    paste( "_")
  })
  output$mod2 <- renderText({
    
    input$bout
    input$seed
    input$run2
    isolate({
      if (input$P){
        paste("The estimated final range is :", round(kR0nugg()$theta(), 3), sep = " ")
      }
      else{
        paste("The estimated final range is :", round(kR0()$theta(), 3), sep = " ")
      }
    })
    
    
  })
  
  output$mod <- renderText({
    
    input$bout
    input$seed
    input$run2
    isolate({
      if (input$P){
        paste("The estimated final deviation is :", round(kR0nugg()$sigma2(),3), sep = " ")
      }
      else{
        paste("The estimated final deviation is :", round(kR0()$sigma2(),3), sep = " ")
      }
    })
  })
  
}

shinyApp(ui=ui, server=server)

