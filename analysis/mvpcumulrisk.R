library(survival)

#---------
#usepbc data as example
head(pbc)

#---------
#fit cox model to pbc data: using treatment status (e.g. vax status)+three covariates
coxmod<-coxph(Surv(time, status==1) ~trt+age+sex+bili + strata(spiders), data=pbc)
summary(coxmod)

#---------
#obtain predictions for each individual under treatment=1 (e.g. vaccinated) at each observed event time

pbc.trt1<-pbc
pbc.trt1$trt<-1

#cumulative baseline hazard
chaz<-basehaz(coxmod,centered = F)$haz

#linear predictor from cox model: beta*X
lp.trt1<-predict(coxmod,newdata=pbc.trt1,type="lp")

#risk estimates at each observed event time for each person
#rows=individuals, columns=time points
risk.trt1<-sapply(1:length(chaz),FUN=function(x){1-exp(-chaz[x]*exp(lp.trt1))})

#now take the average across all individuals at each time point
risk.trt1.mean<-colMeans(risk.trt1)

#---------
#obtain predictions for each individual under treatment=1 (e.g. unvaccinated) at each observed event time

pbc.trt2<-pbc
pbc.trt2$trt<-2

#cumulative baseline hazard
chaz<-basehaz(coxmod,centered = F)$haz

#linear predictor from cox model: beta*X
lp.trt2<-predict(coxmod,newdata=pbc.trt2,type="lp")

#risk estimates at each observed event time for each person
#rows=individuals, columns=time points
risk.trt2<-sapply(1:length(chaz),FUN=function(x){1-exp(-chaz[x]*exp(lp.trt2))})

#now take the average across all individuals at each time point
risk.trt2.mean<-colMeans(risk.trt2)

#---------
#plot

times<-basehaz(coxmod,centered = F)$time

plot(times,risk.trt1.mean,type="s",col="blue")
points(times,risk.trt2.mean,type="s",add=T,col="red")




## using survexp

survexp(
   ~ 1,
  data = pbc.trt1,
  ratetable = coxmod,
)

survexp(
  ~ 1,
  data = pbc.trt2,
  ratetable = coxmod,
)

survexp1 <- survexp(~1, data=pbc.trt1, ratetable=coxmod, method="ederer", times=seq(0, 4000, 100))
survexp2 <- survexp(~1, data=pbc.trt2, ratetable=coxmod, method="ederer", times=seq(0, 4000, 100))


> plot(sfit4b, fun='event', xscale=365.25,
       xlab="Years from sample", ylab="Deaths")
> lines(sfit3, mark.time=FALSE, fun='event', xscale=365.25, lty=2)
> lines(sfit4a, fun='event', xscale=365.25, col=

