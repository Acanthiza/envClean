% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_subspecies_col.R
\name{make_subspecies_col}
\alias{make_subspecies_col}
\title{Make a subspecies column}
\usage{
make_subspecies_col(
  tax_res,
  use_levels = levels(envClean::lurank$rank),
  remove_strings = "\\\\s\\\\(.*\\\\)\\\\s"
)
}
\arguments{
\item{tax_res}{Dataframe. Probably from call to \code{galah::search_taxa()}}

\item{use_levels}{Ordered factor. Ideally with a match for each unique rank
in \code{tax_res}}

\item{remove_brackets}{Character. Vector of regex to remove
from scientific_name before creating the subspecies column}
}
\value{
\code{tax_res} with extra columns \code{subspecies} and \code{rank_adj}. \code{rank} will
be an ordered factor.
}
\description{
Adds a subspecies column within taxonomic results (e.g. from
make_galah_taxonomy or make_gbif_taxonomy). Simultaneously creates a
\code{rank_adj} column that relevels any rank below subspecies to subspecies (i.e.
any rank = form or variety will have rank_adj = subspecies)
}
\examples{
taxa <- c("Acacia lanigera", "Acacia lanigera var. gracilipes", "Spyridium glabrisepalum", "Spyridium eriocephalum var. glabrisepalum")
taxonomy_result <- galah::search_taxa(taxa)
make_subspecies_col(taxonomy_result) |> dplyr::select(search_term, species, subspecies, rank, rank_adj)
}
\keyword{internal}
