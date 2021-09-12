#' Search data packages
#'
#' @description Searches data packages in the EDI Data Repository using the specified Solr query
#'
#' @param query (character) Solr query. See details (below) for searchable fields and \href{https://cwiki.apache.org/confluence/display/solr/}{Apache Solr Wiki} for how to construct a Solr query
#' @param ecotrends (logical) Include "ecotrends" scope in search results.
#' @param lter_landsat (logical) Include "lter-landsat" scope in search results.
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'     
#' @return (xml_document) Search results
#' 
#' @details 
#' Documents in PASTA’s Solr repository can be discovered based on metadata values stored in the following list of searchable fields:
#' 
#' Single-value fields:
#' \itemize{
#'   \item abstract
#'   \item begindate
#'   \item doi
#'   \item enddate
#'   \item funding
#'   \item geographicdescription
#'   \item id
#'   \item methods
#'   \item packageid
#'   \item pubdate
#'   \item responsibleParties
#'   \item scope
#'   \item singledate
#'   \item site
#'   \item taxonomic
#'   \item title
#' }
#' 
#' Multi-value fields:
#' \itemize{
#'   \item author
#'   \item coordinates
#'   \item keyword
#'   \item organization
#'   \item projectTitle
#'   \item relatedProjectTitle
#'   \item timescale
#' }
#'
#' @export
#' 
#' @examples 
#'
search_data_packages <- function(query, ecotrends = FALSE, 
                                 lter_landsat = FALSE, tier = "production") {
  
}
