% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_taxonomy.R
\name{make_taxonomy}
\alias{make_taxonomy}
\title{Make taxonomy lookups}
\usage{
make_taxonomy(
  df,
  taxa_col = "original_name",
  taxonomy_file,
  target_rank = "species",
  limit = TRUE,
  fixes = NULL,
  ...
)
}
\arguments{
\item{df}{Dataframe with taxa column.}

\item{taxa_col}{Character. Name of column with taxa names}

\item{taxonomy_file}{Character. Path to results from \code{envFunc::get_taxonomy()}}

\item{target_rank}{Character. Default is 'species'. At what level of the
taxonomic hierarchy are results desired. This is the most detailed taxonomy
returned. i.e. if genus is the \code{target_rank}, no taxa below genus are
returned. See \code{envFunc::lurank} \code{rank} column.}

\item{limit}{Logical. If true (default), the output taxonomy will be limited
to the input names in \code{df}. Otherwise, all taxa found in \code{taxonomy_file} will
be returned.}

\item{fixes}{Data frame with columns \code{resolved_to} and \code{prefer}. Any \code{taxa}
result in \code{lutaxa} that matches a name in \code{resolved_to} will be changed to
\code{prefer}. Mainly used where legitimate names are used in areas where they do
not exist. e.g. Eastern osprey \emph{Pandion cristatus} does not occur in South
Australia but records of this species in South Australia are assumed to be
legitimate Osprey (\emph{Pandion haliaetus}) records.}

\item{...}{Passed to \code{get_taxonomy()}}
}
\value{
named list with elements:
\item{lutaxa}{Dataframe. For each unique name in \code{taxa_col}, the best
\code{taxa} to use (taking into account \code{target_rank})}
\item{taxonomy}{Dataframe. For each \code{taxa}in \code{lutaxa} a row of taxonomic
hierarchy and matching gbif usageKeys}
}
\description{
Make taxonomy lookups
}
