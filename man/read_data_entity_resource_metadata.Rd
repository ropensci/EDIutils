% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_data_entity_resource_metadata.R
\name{read_data_entity_resource_metadata}
\alias{read_data_entity_resource_metadata}
\title{Read data entity resource metadata}
\usage{
read_data_entity_resource_metadata(packageId, entityId, tier = "production")
}
\arguments{
\item{packageId}{(character) Data package identifier of the form "scope.identifier.revision"}

\item{entityId}{(character) Data entity identifier}

\item{tier}{(character) Repository tier, which can be: "production", "staging", or "development"}
}
\value{
(xml_document) The resource metadata of \code{entityId} in \code{packageId}.
}
\description{
Read data entity resource metadata
}
\examples{
# Get resource metadata for the first data entity in "knb-lter-cce.310.1"
packageId <- "knb-lter-cce.310.1"
entityIds <- list_data_entities(packageId)
read_data_entity_resource_metadata(packageId, entityIds[1])

}