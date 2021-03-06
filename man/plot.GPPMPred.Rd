% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict.R
\name{plot.GPPMPred}
\alias{plot.GPPMPred}
\title{Plotting predictions}
\usage{
\method{plot}{GPPMPred}(x, plotId, ...)
}
\arguments{
\item{x}{object of class \code{GPPMPred} as obtained by \code{\link{predict.GPPM}}}

\item{plotId}{character string or integer. ID of the person for which the predictions should be plotted}

\item{...}{additional arguments (currently not used).}
}
\value{
A plot visualizing the predictive distribution. The bold line describes the mean and the shaded area the 95\% credibility interval.
}
\description{
Plots person-specific predictions
}
\examples{
\donttest{
data("demoLGCM")
#remove all measurements from person 1 and the first form person 2
predIdx <- c(which(demoLGCM$ID==1),which(demoLGCM$ID==2)[1])
fitDemoLGCM <- demoLGCM[setdiff(1:nrow(demoLGCM),predIdx),]

lgcm <- gppm('muI+muS*t','varI+covIS*(t+t#)+varS*t*t#+(t==t#)*sigma',
             fitDemoLGCM,'ID','y')
lgcm <- fit(lgcm)
predRes <- predict(lgcm,demoLGCM[predIdx,])
plot(predRes,1)
}
}
