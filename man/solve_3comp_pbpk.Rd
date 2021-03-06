\name{solve_3comp}
\alias{solve_3comp}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
   Solve_3comp
}
\description{
This function solves for the amounts or concentrations of a chemical in different tissues as functions of time based on the dose and dosing frequency.  It uses a three compartment model with partition coefficients.
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
solve_3comp(chem.name = NULL, chem.cas = NULL, times=NULL,
            parameters=NULL, days=10, tsteps = 4, daily.dose = 1,dose=NULL, 
            doses.per.day=NULL, initial.values=NULL,plots=F, suppress.messages=F, 
            species="Human", iv.dose=F,output.units='uM',
            method="lsoda",rtol=1e-8,
            atol=1e-12,default.to.human=F,recalc.blood2plasma=F,
            recalc.clearance=F,dosing.matrix=NULL,Funbound.plasma.pc.correction=T, 
            restrictive.clearance = T,...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{chem.name}{Either the chemical name, CAS number, or the parameters must be specified.}
  \item{chem.cas}{Either the chemical name, CAS number, or the parameters must be specified.}
  \item{times}{Optional time sequence for specified number of days.  The dosing sequence begins at the beginning of times.}
  \item{parameters}{Chemical parameters from parameterize_3comp function, overrides chem.name and chem.cas.}
  \item{days}{Length of the simulation.}
   \item{tsteps}{The number time steps per hour.}
  \item{daily.dose}{Total daily dose, mg/kg BW.}
  \item{dose}{Amount of a single dose, mg/kg BW.  Overwrites daily.dose.}
  \item{doses.per.day}{Number of doses per day.}
  \item{initial.values}{Vector containing the initial concentrations or amounts of the chemical in specified tissues with units corresponding to output.units.  Defaults are zero.}
  \item{plots}{Plots all outputs if true.}
  \item{suppress.messages}{Whether or not the output message is suppressed.} 
  \item{species}{Species desired (either "Rat", "Rabbit", "Dog", "Mouse", or default "Human"). }
  \item{iv.dose}{Simulates a single i.v. dose if true.}
    \item{output.units}{Desired units (either "mg/L", "mg", "umol", or default "uM").}
    \item{method}{Method used by integrator (deSolve).}
  \item{rtol}{Argument passed to integrator (deSolve).}
  \item{atol}{Argument passed to integrator (deSolve).}
    \item{default.to.human}{
  Substitutes missing animal values with human values if true (hepatic intrinsic clearance or fraction of unbound plasma).
  }
    \item{recalc.blood2plasma}{Recalculates the ratio of the amount of chemical in the blood to plasma using the input parameters, calculated with hematocrit, Funbound.plasma, and Krbc2pu.}
    \item{recalc.clearance}{Recalculates the the hepatic clearance (Clmetabolism) with new million.cells.per.gliver parameter.}
      \item{dosing.matrix}{Vector of dosing times or a matrix consisting of two columns or rows named "dose" and "time" containing the time and amount, in mg/kg BW, of each dose.}
      \item{Funbound.plasma.pc.correction}{Uses corrected Funbound.plasma when set to TRUE along with parition coefficients calculated with this value and regressions.}
 \item{restrictive.clearance}{Protein binding not taken into account (set to 1) in liver clearance if FALSE.}
  \item{...}{Additional arguments passed to the integrator.}
}

\details{
Note that the model parameters have units of hours while the model output is in days.

Default of NULL for doses.per.day solves for a single dose.

The compartments used in this model are the gutlumen, gut, liver, and rest-of-body, with the plasma equivalent to the liver plasma.
%%When species is specified as rabbit, dog, or mouse, the function uses the appropriate physiological data(volumes and flows) but substitues human fraction unbound, partition coefficients, and intrinsic hepatic clearance. 

%%  ~~ If necessary, more details than the description above ~~
}
\value{
A matrix of class deSolve with a column for time(in days) and each compartment, the plasma concentration, area under the curve, and a row for each time point.
     
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}

\author{
John Wambaugh and Robert Pearce
}

\examples{
solve_3comp(chem.name='Bisphenol-A',doses.per.day=2,dose=.5,days=1,tsteps=2)
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{Solve}
