\name{calc_rblood2plasma}
\alias{calc_rblood2plasma}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Calculate the constant ratio of the blood concentration to the plasma concentration.
}
\description{
This function calculates the constant ratio of the blood concentration to the plasma concentration.
}
\usage{
calc_rblood2plasma(chem.cas=NULL, chem.name=NULL, default.to.human=F, 
                   species="Human",Funbound.plasma.pc.correction=T)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{chem.name}{
  Either the chemical name or the CAS number must be specified.
%%     ~~Describe \code{obs} here~~
}
  \item{chem.cas}{
  Either the CAS number or the chemical name must be specified.
%%     ~~Describe \code{pred} here~~
}
  \item{default.to.human}{
  Substitutes missing animal values with human values if true.
  }
  \item{species}{
   Species desired (either "Rat", "Rabbit", "Dog", "Mouse", or default "Human").
%%     ~~Describe \code{ssparams.var.inv} here~~

}
\item{Funbound.plasma.pc.correction}{
 If TRUE, the Funbound.plasma correction is applied in calculating Rblood2plasma.
}

}
\details{
The red blood cell (RBC) parition coefficient as predicted by the Schmitt (2008) method is used in the calculation.
The value is calculated with the equation: 1 - hematocrit + hematocrit * Krbc2pu * Funbound.plasma, summing the red blood cell to plasma 
and plasma:plasma (equal to 1) partition coefficients multiplied by their respective fractional volumes.
%%When species is specified as rabbit, dog, or mouse, the function uses the appropriate physiological data(hematocrit and temperature) but substitues human fraction unbound and tissue volumes. 
%%  ~~ If necessary, more details than the description above ~~
}

\references{
Schmitt W. "General approach for the calculation of tissue to plasma partition coefficients." Toxicology In Vitro, 22, 457-467 (2008).
}
\author{
John Wambaugh
}


%% ~Make other sections like Warning with \section{Warning }{....} ~

\examples{
calc_rblood2plasma(chem.name="Bisphenol A")
calc_rblood2plasma(chem.name="Bisphenol A",species="Rat")
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{Parameter}
