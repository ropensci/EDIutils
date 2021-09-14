#' Search data packages
#'
#' @description Searches data packages in the EDI Data Repository using the specified Solr query. See ADD RESOURCE for constructing queries.
#'
#' @param query (character) Solr query. See details (below) for searchable fields and \href{https://cwiki.apache.org/confluence/display/solr/}{Apache Solr Wiki} for how to construct a Solr query.
#' @param ecotrends (logical) Include "ecotrends" scope in search results. EcoTrends contains NUM_NON_UNIQUE data packages about ...
#' @param lter_landsat (logical) Include "lter-landsat" scope in search results. LTER-Landsat contains NUM_NON_UNIQUE data packages about ...
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'     
#' @return (xml_document) Search results
#' 
#' @note Only the newest version of data packages are searchable (older versions are not).
#' 
#' @details Documents in the EDI Data Repository Solr index can be discovered based on metadata values stored in the following list of searchable fields (not all EML content is queryable):
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
#' \code{query} parser: The optimal query parser (eDisMax) is added if none are included in the query.
#' TODO describe landsat and ecotrends handling
#'
#' @export
#' 
#' @examples 
#'
search_data_packages <- function(query, 
                                 ecotrends = FALSE, 
                                 lter_landsat = FALSE, 
                                 tier = "production") {
  validate_arguments(x = as.list(environment()))
  browser()
  
  # Replace/add query parser
  pattern <- "deftype=[[:alpha:]]*(?=[[:punct:]])"
  deftype <- grepl(pattern, query, ignore.case = TRUE, perl = TRUE)
  if (deftype) {
    # Do nothing
    # query <- sub(pattern, "defType=edismax", query, ignore.case = TRUE, perl = TRUE)
  } else {
    # Add
    query <- paste0(query, "&defType=edismax")
  }
  
  # Replace/add ecotrends
  pattern <- "fq=scope:(-)*ecotrends"
  ecotrends <- grepl(pattern, query, ignore.case = TRUE, perl = TRUE)
  if (ecotrends) {
    # Do nothing
  } else {
    # Add fq based on arg
    # - get fq=.* string and add to end
    # - insert fq string into query
  }
  
  # Replace/add lter-landsat
  pattern <- "fq=scope:(-)*lter-landsat"
  landsat <- grepl(pattern, query, ignore.case = TRUE, perl = TRUE)
  if (landsat) {
    # do nothing
  } else {
    # Add fq based on arg
    # - get fq=.* string and add to end
    # - insert fq string into query
  }
  
  
  query <- gsub(pattern = "\"", replacement = "%22", x = query) # Escape quotes
  
  
  url <- paste0(url_env(tier), 
                ".lternet.edu/package/search/eml?defType=edismax&", query)
  # if (ecotrends) {
  #   url <- paste0(url, "&fq=-scope:ecotrends")
  # } else {
  #   url <- paste0(url, "&fq=scope:ecotrends")
  # }
  # if (lter_landsat) {
  #   url <- paste0(url, "&fq=-scope:lter-landsat")
  # } else {
  #   url <- paste0(url, "&fq=scope:lter-landsat")
  # }
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  httr::stop_for_status(resp)
  parsed <- xml2::read_xml(httr::content(resp, "text", encoding = "UTF-8"))
  return(parsed)
}
