#' httkpop: Virtual population generator for HTTK.
#' 
#' The httkpop package generates virtual population physiologies for use in 
#' population TK.
#' 
#' @section Main function to generate a population: 
#' If you just want to generate
#'   a table of (chemical-independent) population physiology parameters, use 
#'   \code{\link{httkpop_generate}}.
#'   
#' @section Using HTTK-Pop with HTTK: 
#' To generate a population and then run an 
#'   HTTK model for that population, the workflow is as follows: \enumerate{ 
#'   \item Generate a population using \code{\link{httkpop_generate}}. \item For
#'   a given HTTK chemical and general model, convert the population data to 
#'   corresponding sets of HTTK model parameters using 
#'   \code{\link{get_httk_params}}.}
#'   
#'   
#' @import data.table httk survey
#'   
#' @docType package
#' @name httkpop
NULL