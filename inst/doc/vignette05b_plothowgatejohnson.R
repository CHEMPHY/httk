## ---- include=FALSE------------------------------------------------------
knitr::opts_chunk$set(collapse = TRUE, comment = '#>')

## ----load_packages-------------------------------------------------------
library('data.table')
library('httk')
library('ggplot2')
library('RColorBrewer')

## ----read_study_data, eval=FALSE-----------------------------------------
#  jhchem <- readRDS(file="data/jhchem.Rdata")
#  #Get Funbound.plasma measured values from HTTK
#  chem.dt <- as.data.table(httk::get_cheminfo(model='3compartmentss',
#                                              species='Human',
#                                              info=c('CAS', "MW", "Funbound.plasma"),
#                                              exclude.fub.zero=FALSE))
#  #Get CLint measured values from HTTK
#  chem.dt[, Clint:=sapply(CAS,
#                          function(x) parameterize_steadystate(chem.cas=x,
#                                                               species='Human')$Clint)]
#  setnames(chem.dt, 'Human.Funbound.plasma', 'Funbound.plasma')
#  chem.dt[, fup.zero:=Funbound.plasma==0.005]
#  chem.dt[, Clint.zero:=Clint==0]
#  
#  jhchem <- merge(jhchem,chem.dt,by='CAS')

## ---- eval=FALSE---------------------------------------------------------
#  ellipse_fun <- function(x.CI.max,
#                          x.CI.min,
#                          y.CI.max,
#                          y.CI.min,
#                          npts=100){
#    #Compute length of axes
#    a <- (x.CI.max - x.CI.min)/2
#    b <- (y.CI.max - y.CI.min)/2
#    #Compute center point
#    x0 <- mean(c(x.CI.min,x.CI.max))
#    y0 <- mean(c(y.CI.min,y.CI.max))
#    #get x and y coordinates of ellipse circumference
#    ellipse.x <- a*cos(seq(from=0,
#                           to=2*pi,
#                           length.out=npts)) + x0
#    ellipse.y <- b*sin(seq(from=0,
#                           to=2*pi,
#                           length.out=npts)) + y0
#    return(data.table(ellipse.x=ellipse.x,
#                      ellipse.y=ellipse.y))
#  
#    }

## ---- eval=FALSE---------------------------------------------------------
#  plot_virtstudy_innerfunction <- function(model,
#                                                fup.censor,
#                                                poormetab,
#                                           fuptofub,
#                                                jhchem){
#  
#    if (fuptofub){
#    overall.dt <- readRDS(paste0('data/',
#                                 paste('virtstudypop', 'overallstats', model,
#                                       'poormetab', poormetab,
#                                       'fup.censor', fup.censor,
#                                       "FuptoFub", sep='_'),
#                                 '.Rdata'))
#    }else{
#      overall.dt <- readRDS(paste0('data/',
#                                 paste('virtstudypop', 'overallstats', model,
#                                       'poormetab', poormetab,
#                                       'fup.censor', fup.censor, sep='_'),
#                                 '.Rdata'))
#    }
#    overall.dt <- merge(overall.dt,
#                        jhchem[, .(Study.id,
#                                   Compound,
#                                   Total.subjects,
#                                   Clearance.median,
#                                   Clearance.95CI.min,
#                                   Clearance.95CI.max,
#                                   Clearance.units,
#                                   src,
#                                   MW,
#                                   fup.zero,
#                                   Clint.zero)],
#                        by='Study.id')
#    overall.dt[Clearance.units=='1/h',
#               Clearance.units:='L/h'] #correct typo/misreading of "1" for lowercase "L"
#    #For clearances given as L/h/kg:
#    #1 mg/kg/day over L/day/kg = Css in mg/L
#    #Css in mg/L divided by MW in mg/umol = umol/L = uM
#    overall.dt[Clearance.units=='L/h/kg',
#               css.median.invivo:=1/(24*Clearance.median*(MW/1000))]
#    overall.dt[Clearance.units=='L/h/kg',
#               css.95CImax.invivo:=1/(24*Clearance.95CI.min*(MW/1000))]
#    overall.dt[Clearance.units=='L/h/kg',
#               css.95CImin.invivo:=1/(24*Clearance.95CI.max*(MW/1000))]
#    #For clearances given as L/h:
#    #1 mg/kg/day over L/day = mg/L/kg = Css/kg BW
#    #mg/L/kg divided by MW in mg/umol = uM/kg = Css/kg BW
#    overall.dt[Clearance.units=='L/h',
#               css.bw.median.invivo:=1/(24*Clearance.median*(MW/1000))]
#    overall.dt[Clearance.units=='L/h',
#               css.bw.95CImax.invivo:=1/(24*Clearance.95CI.min*(MW/1000))]
#    overall.dt[Clearance.units=='L/h',
#               css.bw.95CImin.invivo:=1/(24*Clearance.95CI.max*(MW/1000))]
#    #Get overall bounds on Css and clearance
#    overall.dt[, mean.css.95CI.max:=mean.css.95CI.max.fold*median.css.median]
#    overall.dt[, mean.css.95CI.min:=mean.css.95CI.min.fold*median.css.median]
#    overall.dt[, mean.css.bw.95CI.max:=mean.css.bw.95CI.max.fold*median.css.bw.median]
#    overall.dt[, mean.css.bw.95CI.min:=mean.css.bw.95CI.min.fold*median.css.bw.median]
#    overall.dt[, poormetab:=poormetab]
#    overall.dt[, fup.censor:=fup.censor]
#    overall.dt[, fuptofub:=fuptofub]
#  
#    #Generate ellipses for Css
#    overall.ellipse <- overall.dt[Clearance.units=='L/h/kg',
#                                  ellipse_fun(x.CI.max=log10(css.95CImax.invivo),
#                                              x.CI.min=log10(css.95CImin.invivo),
#                                              y.CI.max=log10(mean.css.95CI.max),
#                                              y.CI.min=log10(mean.css.95CI.min)),
#                                  by=.(Study.id, Compound, Clearance.units, src)]
#    #Define colors for plotting
#    #from ColorBrewer2.org -- qualitative scale with 12 colors (the max), plus 3 greys
#    colvect <- c(brewer.pal(12, 'Paired'),
#                 c("gray75", "gray50", "black"))
#    names(colvect) <- overall.dt[, unique(Compound)]
#    #swap alprazolam (light blue) and omeprazole (light purple)
#    #makes it easier to tell differences
#    tmp <- colvect['omeprazole']
#    colvect['omeprazole'] <- colvect['alprazolam']
#    colvect['alprazolam'] <- tmp
#    rm(tmp)
#    #colvect['theophylline']<-'gray50'
#    #Set up function to rescale axis labels
#    labels.rescale <- function(){
#      function(x) 10^x
#      }
#  
#  
#    #Generate ellipses for Css/kg BW
#    overall.ellipse2 <- overall.dt[Clearance.units=='L/h',
#                                   ellipse_fun(x.CI.max=log10(css.bw.95CImax.invivo),
#                                               x.CI.min=log10(css.bw.95CImin.invivo),
#                                               y.CI.max=log10(mean.css.bw.95CI.max),
#                                               y.CI.min=log10(mean.css.bw.95CI.min)),
#                                   by=.(Study.id, Compound, Clearance.units, src)]
#  
#  
#  ellipse.dt <- rbind(overall.ellipse, overall.ellipse2)
#  
#  ellipse.dt[Clearance.units=="L/h", Css.units:="Css in uM/kg"]
#  ellipse.dt[Clearance.units=="L/h/kg", Css.units:="Css in uM"]
#  
#  ptest <- ggplot(data=ellipse.dt)
#  
#  for (i in ellipse.dt[, unique(Study.id)]) {
#  ptest <- ptest + geom_path(data=ellipse.dt[Study.id==i,],
#  aes(x=ellipse.x, y=ellipse.y,
#  color=Compound))
#  }
#  
#  ptest<- ptest + geom_abline(slope=1,intercept=0, linetype=2)+
#  scale_color_manual(limits=ellipse.dt[, unique(Compound)],
#  values=colvect)+
#  scale_x_continuous(labels=labels.rescale()) + #force axes equal range
#  scale_y_continuous(labels=labels.rescale()) + #force axes equal range
#  facet_wrap(~Css.units, scales="free") + #, space="free") +
#    coord_fixed(ratio=1) +
#  labs(x=expression(paste(C[ss], ' in vivo')),
#  y=expression(paste(C[ss], ' predicted'))) +
#  theme_bw() +
#  theme(legend.key=element_blank(),
#  aspect.ratio=1,
#  strip.background=element_blank(),
#  legend.position="bottom")
#  
#  
#    return(list(ptest=list(ptest), ov.dt=list(overall.dt)))
#    }

## ---- eval=FALSE---------------------------------------------------------
#  args.dt <- as.data.table(expand.grid(poormetab=c(TRUE, FALSE),
#                           fup.censor=c(TRUE, FALSE),
#                           fuptofub=c(TRUE, FALSE)))
#  out.dt <- args.dt[, plot_virtstudy_innerfunction(model="3compartmentss",
#                                         poormetab=poormetab,
#                                         fup.censor=fup.censor,
#                                         fuptofub=fuptofub,
#                                         jhchem=jhchem),
#          by=.(poormetab, fup.censor, fuptofub)]
#  
#  plotfun <- function(ptmp, poormetab, fup.censor, fuptofub){
#    print(ptmp[[1]] + ggtitle(paste(c("poormetab",
#                                 "fup.censor",
#                                 "Fup to Fub"),
#                               c(poormetab,
#                                 fup.censor,
#                                 fuptofub),
#                               sep=" = ",
#                               collapse=", ")))
#    ggsave(paste0(paste("pdf_figures/howgatejohnson_css_poormetab",
#                 poormetab,
#                 "fupcensor",
#                 fup.censor,
#                 "FuptoFub",
#                 fuptofub,
#                 sep="_"),
#                 ".pdf"),
#           ptmp[[1]],
#           width=8.5,
#           height=5.4)
#  }
#  
#  out.dt[, plotfun(ptmp=ptest,
#                   poormetab=poormetab,
#                   fup.censor=fup.censor,
#                   fuptofub=fuptofub),
#         by=.(poormetab, fup.censor, fuptofub)]

## ---- eval=FALSE---------------------------------------------------------
#  stats.dt <- rbindlist(out.dt[, ov.dt])
#  #Also show a table of how many are within 2-fold, 5-fold, 10-fold
#  #Compare Css medians:
#  stats.dt[src=="Howgate et al. 2006",
#             css.median.pred.over.lit:=median.css.bw.median/css.bw.median.invivo]
#  stats.dt[src=="Johnson et al. 2006",
#             css.median.pred.over.lit:=median.css.median/css.median.invivo]
#  #Compare 95% CI ranges:
#  stats.dt[src=="Johnson et al. 2006",
#             css.95CI.range.pred.over.lit:=(mean.css.95CI.max-mean.css.95CI.min)/(css.95CImax.invivo - css.95CImin.invivo)]
#  stats.dt[src=="Howgate et al. 2006",
#             css.95CI.range.pred.over.lit:=(mean.css.bw.95CI.max-mean.css.bw.95CI.min)/(css.bw.95CImax.invivo - css.bw.95CImin.invivo)]

## ---- eval=FALSE---------------------------------------------------------
#  cssmed.dt <- stats.dt[, list(sum(css.median.pred.over.lit<=2 &
#                                                      css.median.pred.over.lit>=0.5),
#                                                sum(css.median.pred.over.lit<=5 &
#                                                      css.median.pred.over.lit>=0.2),
#                                                sum(css.median.pred.over.lit<=10 &
#                                                      css.median.pred.over.lit>=0.1),
#                                        length(unique(Study.id))),
#                     by=.(poormetab, fup.censor, fuptofub, src)]
#  setnames(cssmed.dt, paste0("V", 1:4), c("within.2fold",
#                         "within.5fold",
#                         "within.10fold",
#                         "Total"))
#  knitr::kable(cssmed.dt,
#               format="html",
#               col.names=c("PMs included?",
#                           "Funbound.plasma censored below avg LOD?",
#                           "Funbound.plasma converted to Funbound.blood?",
#                 "Data from",
#                           "Within 2-fold",
#                           "Within 5-fold",
#                           "Within 10-fold",
#                           "Total"),
#               caption="Css median, predicted vs. literature in vivo, number of studies")

## ---- eval=FALSE---------------------------------------------------------
#  css95CI.dt <- stats.dt[, list(sum(css.95CI.range.pred.over.lit<=2 &
#                                                      css.95CI.range.pred.over.lit>=0.5),
#                                                sum(css.95CI.range.pred.over.lit<=5 &
#                                                      css.95CI.range.pred.over.lit>=0.2),
#                                                sum(css.95CI.range.pred.over.lit<=10 &
#                                                      css.95CI.range.pred.over.lit>=0.1),
#                                        length(unique(Study.id))),
#                     by=.(poormetab, fup.censor, fuptofub, src)]
#  setnames(css95CI.dt, paste0("V", 1:4), c("within.2fold",
#                         "within.5fold",
#                         "within.10fold",
#                         "Total"))
#  knitr::kable(css95CI.dt,
#               format="html",
#               col.names=c("PMs included?",
#                           "Funbound.plasma censored below avg LOD?",
#                           "Funbound.plasma converted to Funbound.blood?",
#                 "Data from",
#                           "Within 2-fold",
#                           "Within 5-fold",
#                           "Within 10-fold",
#                           "Total"),
#               caption="Css 95% CI range, predicted vs. literature in vivo, number of studies")

