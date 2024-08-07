% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_galah_taxonomy.R
\name{make_taxonomy}
\alias{make_taxonomy}
\title{Get taxonomy via \code{galah::taxa_search()}}
\usage{
make_taxonomy(
  df = NULL,
  taxa_col = "original_name",
  taxonomy_file = tempfile(),
  force_new = list(original_name = NULL, timediff = as.difftime(26, units = "weeks")),
  remove_taxa = c("bold:", "BOLD:", "unverified", "annual herb", "annual grass",
    "incertae sedis", "\\\\?", "another species", "not naturalised in SA",
    "unidentified", "unverified", "annual tussock grass", "*no id"),
  remove_strings = c("\\\\s\\\\-\\\\-\\\\s.*", "\\\\ssp\\\\.$", "\\\\sssp\\\\.$",
    "\\\\sspec\\\\.$", "dead"),
  atlas = c("Australia"),
  return_taxonomy = TRUE,
  limit = TRUE,
  needed_ranks = c("species"),
  overrides = NULL
)
}
\arguments{
\item{df}{Dataframe with \code{taxa_col}. Can be NULL only if taxonomy_file
already exists.}

\item{taxa_col}{Character or index. Name or index of column with taxa names.
Each unique taxa in this column will appear in the results list element
\code{lutaxa}in a column called \code{original_name}}

\item{taxonomy_file}{Character. File path to save results to. File type
ignored. .parquet file used, partitioned on kingdom. If using this file
directly (rather than via return_taxonomy = TRUE) remember to ungroup the
result returned via \code{arrow::open_dataset()}.}

\item{force_new}{List with elements \code{taxa_col} and \code{difftime}. If
\code{taxonomy_file} already exists any \code{taxa_col} matches between \code{force_new} and
\code{taxonomy_file} will be requeried. Likewise any \code{original_name} that has not
been searched since \code{difftime} will be requeried. Note the name \code{taxa_col}
should be as provided as per the \code{taxa_col} argument. Set either to \code{NULL}
to ignore.}

\item{remove_taxa}{Character. Rows with regular expressions that match
\code{remove_taxa} are removed (rows are removed).}

\item{remove_strings}{Character. Text that matches \code{remove_strings} is
removed from the string before searching (text, not row, is removed).}

\item{return_taxonomy}{Logical. If \code{TRUE}, a list is returned containing the
best match for each original_name in \code{lutaxa} and additional elements named
for their rank (see \code{envClean::lurank}) with unique rows for that rank. One
element per rank provided in \code{needed_ranks}}

\item{limit}{Logical. If \code{TRUE} the returned list will be limited to those
\code{original_name}s in \code{df}}

\item{needed_ranks}{Character vector of ranks required in the returned list.
Can be "all" or any combination of ranks from \code{envClean::lurank} greater than
or equal to \emph{subspecies}.}
}
\value{
Null or list (depending on \code{return_taxonomy}). Writes
\code{taxonomy_file}. \code{taxa_col} will be \code{original_name} in any outputs.
If list, then elements:
\itemize{
\item raw - the 'raw' results returned from \code{galah::search_taxa()}, tweaked
by column \code{rank} being an ordered factor as per \code{envClean::lurank}.
\item needed_ranks - One element for each rank specified in \code{needed_ranks}.
\itemize{
\item lutaxa - dataframe. For each unique name in \code{taxa_col}, the best
\code{taxa} taxonomic bin to use, for each \code{original_name}, taking into
account each level of \code{needed_ranks}
\itemize{
\item original_name - unique values from \code{taxa_col}
\item match_type - directly from \code{galah::search_taxa()}
\item matched_rank - \code{rank} column from \code{galah::search_taxa()}
\item returned_rank - the rank of the \code{taxa} returned for each
\code{original_name}. This will never be lower than \code{needed_rank} but
may be higher than \code{needed_rank} if no match was available at
\code{needed_rank}. Use this 'rank' to filter bins in a cleaning
workflow
\item taxa - the best taxa available for \code{original_name} at
\code{needed_rank}, perhaps taking into account \code{overrides}
\item override - is the \code{taxa} the result of an override?
}
\item taxonomy - dataframe. For each \code{taxa} in \code{lutaxa} a row of
taxonomic hierarchy
}
}
}
\description{
Only queries galah for taxa not already in \code{taxonomy_file}. Can return a list,
for several levels of taxonomic hierarchy, with the 'best' match at that
level. For example, if 'genus' is provided in \code{needed_ranks}, the returned
list will have an element 'genus' that contains, in a column named \code{taxa},
and for each of the original names provided, the best result at genus level
\emph{or higher} (in cases where no genus level match was available).
}
\details{
Previous \code{envClean::make_taxonomy()} function is still available via
\code{envClean::make_gbif_taxonomy()}
}
\examples{

  # setup
  library("envClean")

  temp_file <- tempfile()

  taxa_df <- tibble::tibble(taxa = c("Charadrius rubricollis"
                                      , "Thinornis cucullatus"
                                      , "Melithreptus gularis laetior"
                                      , "Melithreptus gularis gularis"
                                      , "Eucalyptus viminalis"
                                      , "Eucalyptus viminalis cygnetensis"
                                     , "Eucalyptus"
                                      )
                            )

  # make taxonomy (returns list and writes taxonomy_file)
  taxonomy <- make_taxonomy(df = taxa_df
                            , taxa_col = "taxa"
                            , taxonomy_file = temp_file
                            , needed_ranks = c("kingdom", "genus", "species", "subspecies")
                            )
  taxonomy$raw
  taxonomy$kingdom
  taxonomy$genus
  taxonomy$species
  taxonomy$subspecies

  # query more taxa (results are added to taxonomy_file but only the new taxa are returned (default `limit = TRUE`)
  more_taxa <- tibble::tibble(original_name = c("Amytornis whitei"
                                                , "Amytornis striatus"
                                                , "Amytornis modestus (North, 1902)"
                                                , "Amytornis modestus modestus"
                                                , "Amytornis modestus cowarie"
                                                )
                              )

  taxonomy <- make_taxonomy(df = more_taxa
                            , taxonomy_file = temp_file
                            , needed_ranks = c("species")
                            )

  taxonomy$species

  # no dataframe supplied - all results in taxonomy_file returned
  taxonomy <- make_taxonomy(taxonomy_file = temp_file
                            , needed_ranks = c("subspecies")
                            )

  taxonomy$subspecies

  # overrrides
  overrides <- envClean::taxonomy_overrides

  # C. rubricollis binned to Phalarope lobatus at species level!
  taxonomy <- make_taxonomy(df = overrides
                            , taxonomy_file = temp_file
                            , needed_ranks = c("species")
                            )

  taxonomy$species

  # add in override - C. rubricollis is binned to T. cucullatus at species level
  taxonomy <- make_taxonomy(df = overrides
                            , taxonomy_file = temp_file
                            , needed_ranks = c("species", "subspecies")
                            , overrides = overrides
                            )

  taxonomy$species
  taxonomy$subspecies

  # clean up
  rm(taxonomy)
  unlist(temp_file)
}
