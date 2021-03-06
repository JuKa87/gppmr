new_FitRes <- function(paraEsts,vcov,LL,nPar,mu,Sigma){
  stopifnot(is.double(paraEsts)) #maximum likelihood estimates
  stopifnot(is.matrix(vcov)) #covariance of sampling distribution of maximum likelihood estimator
  stopifnot(is.double(LL) && length(LL)==1)
  stopifnot(is.integer(nPar) && length(nPar)==1)
  stopifnot(is.list(mu))
  stopifnot(is.list(Sigma))

  structure(list(
    paraEsts=paraEsts,
    vcov=vcov,
    LL=LL,
    nPar=nPar,
    mu=mu,
    Sigma=Sigma
  ),
  class='StanData'
  )
}

extractMoments <- function(stanOutParas,dataStats){
  mu <- rep(list(numeric(dataStats$maxTime)),dataStats$nPer)
  Sigma <- rep(list(matrix(nrow=dataStats$maxTime,ncol = dataStats$maxTime)),dataStats$nPer)
  for (iPer in seq_len(dataStats$nPer)){
    mu[[iPer]] <- stanOutParas$mu[iPer,1:dataStats$nTime[iPer]]
    Sigma[[iPer]] <- stanOutParas$Sigma[iPer,1:dataStats$nTime[iPer],1:dataStats$nTime[iPer]]
  }
  res <- list(mu=mu,Sigma=Sigma,IDs=attr(dataStats,'IDs'))
}


extractLL <- function(meanCov,dataStats){
  Y <- dataStats$Y
  ll <- 0
  for (i in 1:length(Y)){
    ll <- ll + mvtnorm::dmvnorm(Y[[i]][1:dataStats$nTime[i]],mean=meanCov$mu[[i]],sigma=as.matrix(meanCov$Sigma[[i]]),log=TRUE)
  }
  ll
}

extractFitRes <- function(stanOut,parsedModel,dataStats){
  paraEsts <- stanOut$par[parsedModel$params]
  theNames <- names(paraEsts)
  paraEsts <- as.numeric(paraEsts)
  names(paraEsts) <- theNames
  vcov <- as.matrix(NA)
  if (!is.null(stanOut$hessian)){
    tryCatch(vcov <- solve(-stanOut$hessian),error=function(e){})
  }

  nPar <- length(parsedModel$params)
  meanCov <- extractMoments(stanOut$par,dataStats)
  LL <- extractLL(meanCov,dataStats)
  mu=meanCov$mu
  Sigma=meanCov$Sigma
  new_FitRes(paraEsts,vcov,LL,nPar,mu,Sigma)
}
