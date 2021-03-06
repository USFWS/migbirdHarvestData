% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validate.R
\name{validate}
\alias{validate}
\title{Validate data}
\usage{
validate(x, type, all = FALSE, period = NA)
}
\arguments{
\item{x}{The object created after cleaning data with \code{\link{clean}}}

\item{type}{Type of validation to perform. Acceptable values include:
\itemize{
\item vertical - Checks for repetition vertically in species and/or bag fields, grouped by dl_state and dl_date
\item horizontal - Checks for repetition horizontally, across each record
}}

\item{all}{Should all species groups be checked (TRUE)? If set to FALSE (default), then only ducks will be vertically checked and only ducks, geese, doves, and woodcock will be horizontally checked.}

\item{period}{Time period in which to group the data. The function uses dl_date automatically, but either of the following may be supplied:
\itemize{
\item dl_date - Date the HIP data were downloaded
\item dl_cycle - Download cycle that the HIP data belong to
}}
}
\description{
After cleaning the data with \code{\link{clean}}, check to make sure the data don't have any erroneously repeated values.
}
\references{
\url{https://github.com/USFWS/migbirdHarvestData}
}
\author{
Abby Walter, \email{abby_walter@fws.gov}
}
