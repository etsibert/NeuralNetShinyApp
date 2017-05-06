
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(neuralnet)

shinyServer(function(input, output) {


  observeEvent(input$btnTrain,{
    set.seed(123)
    hiddenNodesL1<-as.numeric(input$nNodesL1)
    hiddenNodesL2<-as.numeric(input$nNodesL2)
    x<-as.numeric(input$xRange[1]):as.numeric(input$xRange[2])
    if(input$Function=="f1"){
      withProgress(message = 'Training Neural Net',detail = 'This may take a while...', value = 0, {
        y<-x^2
        df<-data.frame(X=x, Y=y)
        incProgress(1/8)
        model_nn<-neuralnet(Y~X,data=df,hidden=c(hiddenNodesL1,hiddenNodesL2),linear.output=T, rep=50, stepmax=10000) 
        y_hat<-compute(model_nn, df$X)
        incProgress(2/8)
      
        df$y_nn<-y_hat$net.result
        df$error<-df$Y-df$y_nn
        incProgress(3/8)
      
        output$mainPlot<-renderPlot({
          plot(df$X, df$Y, col="red", type="o", xlab="", ylab="")
          par(new=T)
          plot(df$X, y_hat$net.result, col="blue",xlab="", ylab="")
          par(new=T)
          plot(df$X, y_hat$net.result, type="l", col="black",xlab="X", ylab="x^2 and Neural Approx.", main="sin(x)+error vs Neural Net Approximation")
          legend('bottomright',legend=c('y=x^2','Neural Net'),pch=18,col=c('red','blue'), bty='n')
        })
        incProgress(4/8)
        output$net<-renderPlot({plot(model_nn, rep="best")})
        incProgress(5/8)
        output$boxPlot<-renderPlot({boxplot(df$error, main="Neural Net Error")})
        incProgress(6/8)
        output$df<-renderTable(df)
        incProgress(7/8)
        MSE<-sum((df$Y-df$y_nn)^2)/length(df$Y)
        output$MSE<-renderText(paste("MSE=",MSE, sep=" "))
        incProgress(8/8)
      })
    }
    else{
      withProgress(message = 'Training Neural Net',detail = 'This may take a while...', value = 0, {
        y<-sin(x)+0.2*rnorm(1)
        df<-data.frame(X=x, Y=y)
        incProgress(1/8)
        model_nn<-neuralnet(Y~X,data=df,hidden=c(hiddenNodesL1,hiddenNodesL2), stepmax =10000,rep=50,linear.output=T) 
        y_hat<-compute(model_nn, df$X)
        incProgress(2/8)
        df$y_nn<-y_hat$net.result
        df$error<-df$Y-df$y_nn
        incProgress(3/8)
        output$mainPlot<-renderPlot({
          plot(df$X, df$Y, col="red", type="o", xlab="", ylab="")
          par(new=T)
          plot(df$X, y_hat$net.result, col="blue",xlab="", ylab="")
          par(new=T)
          plot(df$X, y_hat$net.result, type="l", col="black",xlab="X", ylab="sin(x)+error and Neural Approx.", main="sin(x)+error vs Neural Net Approximation")
          legend('bottomright',legend=c('y=sin(x)+error','Neural Net'),pch=18,col=c('red','blue'), bty='n')
        })
        incProgress(4/8)
        output$net<-renderPlot({plot(model_nn, rep="best")})
        incProgress(5/8)
        output$boxPlot<-renderPlot({boxplot(df$error, main="Neural Net Error")})
        incProgress(6/8)
        output$df<-renderTable(df)
        incProgress(7/8)
        MSE<-sum((df$Y-df$y_nn)^2)/length(df$Y)
        output$MSE<-renderText(paste("MSE=",MSE, sep=" "))
        incProgress(8/8)
      })
    }
  })

})
