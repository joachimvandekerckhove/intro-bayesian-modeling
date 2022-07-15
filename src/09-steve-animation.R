#from Joachim's lecture
prior      <- function(p) { dbeta(2 * (p-.5), 2, 2) }
likelihood <- function(p) { dbinom(5, 6, p) }
post.usc   <- function(p) { prior(p) * likelihood(p) }

par(mfrow=c(1,3))
curve(prior, 0.5, 1)
curve(likelihood, 0.5, 1)
curve(post.usc, 0.5, 1)

#plot posterior and proposal distribution
x11()
plot(curve(post.usc, 0.5, 1),las=1,ylim=c(0,1),xlim=c(.45,1.05),type="l",lwd=2,ylab="Density",xlab="X")
lines(seq(.5,1.,length.out=100),c(0,rep(.9,98),0),col="red",lwd=2)
cord.x <- c(0.5,seq(.5,1,0.01),1) 
cord.y <- c(0,post.usc(seq(.5,1,0.01))-.002,0) 
polygon(cord.x,cord.y,col='gray')
abline(h=0,lwd=4)


#efficient rejection sampler
M<- .567
samples<-na.omit(vapply(runif(1e3,.5,1),
                        FUN=function(x) {if (runif(1)*M < post.usc(x)) {return(x)} else {return(NA)}},numeric(1)))
hist(samples)


#animate rejection sampler
x11()
plot(curve(post.usc, 0.5, 1),las=1,ylim=c(0,1),xlim=c(.45,1.05),type="l",lwd=2,ylab="Density",xlab="X")
lines(seq(.5,1.,length.out=100),c(0,rep(.567,98),0),col="red",lwd=2)
cord.x <- c(0.5,seq(.5,1,0.01),1) 
cord.y <- c(0,post.usc(seq(.5,1,0.01))-.002,0) 
polygon(cord.x,cord.y,col='lightgray')
abline(h=0,lwd=4)


pt<-3  #time in seconds to pause
Sys.sleep(pt)
for (i in 1:10000) {
  xval <- runif(1,.5,1)
  rug(xval,col="red",lwd=2)
  check <- runif(1)*M
  if(check>.02) {arrows(.45,check,.48,length=.1,col="red",lwd=2)}
  if (check < post.usc(xval)) {
    points(xval,check,pch=21,bg="black")
  } else {
    points(xval,check,pch=4)
  }
  pt <- pt-.1
  if (pt>0) {Sys.sleep(pt)}
  if (check>.02) {arrows(.45,check,.48,length=.1,col="white",lwd=2)}
}



#animate MCMC 
Mf <- M/3.78  #approximate
x11()
plot(curve(post.usc, 0.5, 1),las=1,ylim=c(0,1),xlim=c(.45,1.05),type="l",lwd=2,ylab="Density",xlab="X")
cord.x <- c(0.5,seq(.5,1,0.01),1) 
cord.y <- c(0,post.usc(seq(.5,1,0.01))-.002,0) 
polygon(cord.x,cord.y,col='lightgray')
abline(h=0,lwd=4)


pt<-3  #time in seconds to pause
Sys.sleep(pt)
chain <- rep(0,10000)
chain[1] <- runif(1,.5,1)
for (i in 2:10000) {
  current <- chain[i-1]
  proposal <- min(max(current+rnorm(1,0,.1),.5),1)
  if (pt>0) {Sys.sleep(pt)}
  rug(proposal,col="blue",lwd=2)
  
  cdens <- post.usc(current)
  pdens <- post.usc(proposal)
  if(cdens>.02) {arrows(.45,cdens,.48,length=.1,col="red",lwd=2)}
  if(pdens>.02) {arrows(.45,pdens,.48,length=.1,col="blue",lwd=2)}
  
  if (pdens > cdens) {
    chain[i] <- proposal
  } else {
    chain[i] <- ifelse(runif(1) < pdens/cdens, proposal,current) 
  }
  if ((i %% 10)==0) {
    xx<-hist(chain,plot=FALSE)
    for (j in 1:length(xx$mids)) {
        points(xx$mids[j],xx$density[j]*Mf,pch=21,bg="red",col="red")
    }
  }
  
  pt <- pt-.1
  if (pt>0) {Sys.sleep(pt)}
  if (chain[i]==proposal) {
    rug(proposal,col="red",lwd=2)
    if(cdens>.02) {arrows(.45,cdens,.48,length=.1,col="white",lwd=2)}
    if(pdens>.02) {arrows(.45,pdens,.48,length=.1,col="red",lwd=2)}
  } else {
    if(cdens>.02) {arrows(.45,cdens,.48,length=.1,col="white",lwd=2)}
    if(pdens>.02) {arrows(.45,pdens,.48,length=.1,col="white",lwd=2)}
  }
}


