\name{calc_mc_css}
\alias{calc_mc_css}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Find the monte carlo steady state concentration.
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
This function finds the analytical steady state plasma concentration(from calc_analytic_css) using a monte carlo simulation (monte_carlo).
}
\usage{
calc_mc_css(chem.cas=NULL,chem.name=NULL,parameters=NULL,daily.dose=1,
            which.quantile=0.95,species="Human",output.units="mg/L",suppress.messages=F,
            censored.params=list(Funbound.plasma=list(cv=0.3,lod=0.01)),
            vary.params=list(BW=0.3,Vliverc=0.3,Qgfrc=0.3,Qtotal.liverc=0.3,
            million.cells.per.gliver=0.3,Clint=0.3),samples=1000,
            return.samples=F,default.to.human=F,tissue=NULL,well.stirred.correction=T,
            Funbound.plasma.pc.correction=T,restrictive.clearance=T,httkpop=T,
            model='3compartmentss',poormetab=T,fup.censor=T,Clint.vary=T,
            sigma.factor=0.3,lod=0.01,method='direct resampling',
            gendernum=NULL,agelim_years=NULL,agelim_months=NULL,
            weight_category =  c("Underweight", "Normal", "Overweight", "Obese"),
            gfr_category = c("Normal", "Kidney Disease", "Kidney Failure"),
            reths = c("Mexican American", "Other Hispanic", "Non-Hispanic White",
            "Non-Hispanic Black", "Other"),physiology.matrix=NULL,parameter.matrix=NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
 \item{chem.name}{
  Either the chemical parameters, name, or the CAS number must be specified.
%%     ~~Describe \code{obs} here~~
}
  \item{chem.cas}{
  Either the CAS number, parameters, or the chemical name must be specified.
%%     ~~Describe \code{pred} here~~
}
  \item{parameters}{Parameters from parameterize_steadystate. Not used with httkpop model.}
  \item{daily.dose}{Total daily dose, mg/kg BW/day.}
  \item{which.quantile}{
   Which quantile from Monte Carlo simulation is requested. Can be a vector.
%%     ~~Describe \code{ssparams.mean} here~~
}
  \item{species}{
   Species desired (either "Rat", "Rabbit", "Dog", "Mouse", or default "Human").  
   Species must be set to "Human" to run httkpop model. 
%%     ~~Describe \code{ssparams.var.inv} here~~
}
  \item{output.units}{Plasma concentration units, either uM or default mg/L.}
  \item{suppress.messages}{Whether or not to suppress output message.}
  \item{censored.params}{The parameters listed in censored.params are sampled from a normal distribution 
that is censored for values less than the limit of detection (specified separately
for each paramter). This argument should be a list of sub-lists. Each sublist 
is named for a parameter in "parameters"
and contains two elements: "CV" (coefficient of variation) and "LOD" (limit of
detection, below which parameter values are censored. New values are sampled 
with mean equal to the value in "parameters" and standard deviation equal to the 
mean times the CV.  Censored values are sampled on a uniform distribution between
0 and the limit of detection. Not used with httkpop model.}
  \item{vary.params}{The parameters listed in vary.params are sampled from a normal distribution that is
truncated at zero. This argument should be a list of coefficients of variation 
(CV) for the normal distribution. Each entry in the list is named for a 
parameter in "parameters". New values are sampled with mean equal to the value in
"parameters" and standard deviation equal to the mean times the CV. Not used with httkpop model.}
  \item{samples}{Number of samples generated in calculating quantiles.}
  \item{return.samples}{Whether or not to return the vector containing the samples from the simulation instead of the selected quantile.}
    \item{default.to.human}{
  Substitutes missing rat values with human values if true.
  }
  \item{tissue}{Desired steady state tissue conentration.}
  \item{Funbound.plasma.pc.correction}{Uses corrected Funbound.plasma when set to TRUE along with parition coefficients calculated with this value and regressions.}
  \item{well.stirred.correction}{Uses correction in calculation of hepatic clearance for well-stirred model if TRUE for model 1compartment and 3compartmentss.  
                                  This assumes clearance relative to amount unbound in whole blood instead of plasma, but converted to use with plasma concentration.}
 \item{restrictive.clearance}{Protein binding not taken into account (set to 1) in liver clearance if FALSE.}
  \item{httkpop}{Whether or not to use population generator and sampler from httkpop.  This is overwrites censored.params and  vary.params and is only for human physiology.  Species must also be set to 'Human'.}
   \item{model}{Model used in calculation: 'pbtk' for the multiple compartment model,'3compartment' for the three compartment model, '3compartmentss' for the three compartment steady state model, and '1compartment' for one compartment model.  This only applies when httkpop=TRUE and species="Human", otherwise '3compartmentss' is used.}
   
\item{poormetab}{TRUE (include poor metabolizers) or FALSE (exclude poor 
metabolizers)}

\item{fup.censor}{TRUE (draw \code{Funbound.plasma} from a censored 
distribution) or FALSE (draw \code{Funbound.plasma} from a non-censored 
distribution)}

\item{sigma.factor}{The coefficient of variation to use for \code{Clint} and 
\code{Funbound.plasma} distributions. Default value is 0.3.}

\item{Clint.vary}{TRUE (sample \code{Clint} values) or FALSE (hold 
\code{Clint} fixed). Default TRUE. If \code{Clint.vary} is FALSE, then 
\code{poormetab} will have no effect.}

\item{lod}{The average limit of detection for Funbound.plasma. if 
\code{fup.censor == TRUE}, the \code{Funbound.plasma} distribution will be 
censored below \code{lod/2}. Default value is 0.01.}   
  
\item{method}{The population-generation method to use. Either "virtual 
individuals" or "direct resampling" (default). Short names may be used: "d" or "dr" 
for "direct resampling", and "v" or "vi" for "virtual individuals".}

\item{gendernum}{Optional: A named list giving the numbers of male and female 
individuals to include in the population, e.g. \code{list(Male=100, 
Female=100)}. Default is NULL, meaning both males and females are included, 
in their proportions in the NHANES data. If both \code{nsamp} and 
\code{gendernum} are provided, they must agree (i.e., \code{nsamp} must be 
the sum of \code{gendernum}).}

\item{agelim_years}{Optional: A two-element numeric vector giving the minimum 
and maximum ages (in years) to include in the population. Default is 
c(0,79). If only a single value is provided, both minimum and maximum ages 
will be set to that value; e.g. \code{agelim_years=3} is equivalent to 
\code{agelim_years=c(3,3)}. If \code{agelim_years} is provided and 
\code{agelim_months} is not, \code{agelim_years} will override the default 
value of \code{agelim_months}.}

\item{agelim_months}{Optional: A two-element numeric vector giving the minimum
and maximum ages (in months) to include in the population. Default is c(0, 
959), equivalent to the default \code{agelim_years}. If only a single value
is provided, both minimum and maximum ages will be set to that value; e.g.
\code{agelim_months=36} is equivalent to \code{agelim_months=c(36,36)}. If
\code{agelim_months} is provided and \code{agelim_years} is not,
\code{agelim_months} will override the default values of \code{agelim_years}.}

\item{weight_category}{Optional: The weight categories to include in the 
population. Default is \code{c('Underweight', 'Normal', 'Overweight', 
'Obese')}. User-supplied vector must contain one or more of these strings.}

\item{gfr_category}{The kidney function categories to include in the 
population. Default is \code{c('Normal','Kidney Disease', 'Kidney Failure')}
to include all kidney function levels.}

\item{reths}{Optional: a character vector giving the races/ethnicities to 
include in the population. Default is \code{c('Mexican American','Other 
Hispanic','Non-Hispanic White','Non-Hispanic Black','Other')}, to include 
all races and ethnicities in their proportions in the NHANES data. 
User-supplied vector must contain one or more of these strings.}
%%     ~~Describe \code{pred} here~~
\item{physiology.matrix}{A data table generated by \code{httkpop_generate()}.}
\item{parameter.matrix}{A data table generated by \code{get_httk_params()}.}
}


\details{
All arguments after httkpop only apply if httkpop is set to TRUE and species to "Human", the defaults.

%%  When species is specified as rabbit, dog, or mouse, the function uses the appropriate physiological data(volumes and flows) but substitues human fraction unbound, partition coefficients, and intrinsic hepatic clearance. 

Tissue concentrations are calculated for the pbtk model with oral infusion dosing.  All tissues other than gut, liver, and lung are the product of the steady state plasma concentration and the tissue to plasma partition coefficient.
}

\author{
John Wambaugh
}


%% ~Make other sections like Warning with \section{Warning }{....} ~


\examples{
\dontrun{
 calc_mc_css(chem.name='Bisphenol A',output.units='uM',method='vi',
             samples=100,return.samples=TRUE)
 calc_mc_css(chem.name='2,4-d',which.quantile=.9,httkpop=FALSE,tissue='heart')

calc_mc_css(chem.cas = "80-05-7", daily.dose = 1, which.quantile = 0.5,
censored.params = list(Funbound.plasma = list(cv = 0.1, lod = 0.005)),
vary.params = list(BW = 0.15, Vliverc = 0.15, Qgfrc = 0.15,
Qtotal.liverc = 0.15, million.cells.per.gliver = 0.15, Clint = 0.15),
output.units = "uM", samples = 2000)

}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
}
\keyword{Monte Carlo}
\keyword{Steady State}% __ONLY ONE__ keyword per line
