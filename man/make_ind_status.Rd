% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_ind_status.R
\name{make_ind_status}
\alias{make_ind_status}
\title{Make indigenous status lookup}
\usage{
make_ind_status(df, taxa_col = "taxa", ind_col = "ind")
}
\arguments{
\item{df}{Dataframe with taxa column and column indicating indigenous
status.}

\item{taxa_col}{Character. Name of column with taxa.}

\item{ind_col}{Character. Name of column with indigenous status (assumed to
be, largely, \code{Y} or \code{N}).}
}
\value{
Dataframe with unique taxa and their indigenous status.
}
\description{
Make indigenous status lookup
}
