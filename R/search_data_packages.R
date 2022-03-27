#' Search data packages
#'
#' @description Searches data packages in the EDI data repository using the
#' specified Solr query.
#'
#' @param query (character) Query (see details below)
#' @param as (character) Format of the returned object. Can be: "data.frame" 
#' or "xml".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame or xml_document) Search results containing the fields:
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
#'   \item site
#'   \item taxonomic
#'   \item title
#'   \item authors
#'   \item spatialCoverage
#'   \item sources
#'   \item keywords
#'   \item organizations
#'   \item singledates
#'   \item timescales
#' }
#'
#' @note Only the newest version of data packages are searchable, older
#' versions are not.
#'
#' When constructing a query note that the 15403 data packages of the
#' \href{https://lternet.edu/the-ecotrends-project/}{ecotrends} project and
#' 10492 data packages of the
#' \href{https://lternet.edu/lter-remote-sensing-and-geographic-information-system-data/}{LTER Landsat}
#' project, can be excluded from the returned results by including
#' \code{&fq=-scope:(ecotrends+lter-landsat)} in the query string.
#'
#' @details Documents in the EDI data repository Solr index can be discovered
#' based on metadata values stored in the following list of searchable fields
#' (not all EML content is queryable):
#'
#' Single-value fields:
#' \itemize{
#'   \item abstract
#'   \item begindate - In ISO format (YYYY-MM-DDThh:mm:ss)
#'   \item doi
#'   \item enddate - In ISO format (YYYY-MM-DDThh:mm:ss)
#'   \item funding
#'   \item geographicdescription
#'   \item id
#'   \item methods
#'   \item packageid - Data Id in "scope.identifier.revision" format 
#'   \item pubdate - In ISO format (YYYY-MM-DDThh:mm:ss)
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
#'   \item coordinates - Use \code{"IsWithin(West+East+North+South)"} where each 
#'   cardinal direction is in decimal degrees with South of the equator as
#'   negative and East of the prime meridian positive.
#'   \item keyword
#'   \item organization
#'   \item projectTitle
#'   \item relatedProjectTitle
#'   \item timescale
#' }
#'
#' \code{query} parser: The optimal query parser (defType=edismax) is added to
#' every query.
#'
#' See \href{https://cwiki.apache.org/confluence/display/solr/}{Apache Solr Wiki} for how to construct a Solr query.
#' 
#' @family Browse and Discovery
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Search for data packages containing the term "air temperature"
#' res <- search_data_packages(query = 'q="air+temperature"&fl=*')
#' 
#' # Search for data packages containing the term "air temperature" and
#' # returning only the packageid, title, and score of each match
#' res <- search_data_packages(query = 'q="air+temperature"&fl=packageid,title,score')
#' 
#' # Search for data packages containing the term "air temperature", returning
#' # only the packageid, title, score, and excluding ecotrends and lter-landsat
#' # scopes from the returned results
#' query <- paste0('q="air+temperature"&fl=packageid,title,score&',
#'                 'fq=-scope:(ecotrends+lter-landsat)')
#' res <- search_data_packages(query)
#' }
search_data_packages <- function(query, 
                                 as = "data.frame", 
                                 env = "production") {
  # A two part query is needed to get the full result set. First get the number 
  # of results matching the query, then submit a second query to return that
  # number of results.
  # First query
  query <- gsub(pattern = "\"", replacement = "%22", x = query)
  url <- paste0(
    base_url(env),
    "/package/search/eml?defType=edismax&", query
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  numfound <- xml2::xml_attr(res, "numFound")
  # Second query
  url <- paste0(url, "&rows=", numfound)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- xml2::read_xml(res)
  ifelse(as == "data.frame", return(xml2df(res)), return(res))
}
