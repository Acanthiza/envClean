% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/add_lifeform.R
\name{add_lifeform}
\alias{add_lifeform}
\title{Generate best guess of lifeform for each taxa*context}
\usage{
add_lifeform(df, context = "cell", env_prcomp, lulife)
}
\arguments{
\item{df}{Dataframe with context, taxa and lifeform columns.}

\item{context}{Character. Name of columns defining context.}

\item{env_prcomp}{List. Result from call to \code{envClean::env_pca()}}

\item{lulife}{Dataframe lookup for lifeform.}
}
\value{
Dataframe with best guess lifeform replacing original lifeform.
}
\description{
Generate best guess of lifeform for each taxa*context
}
