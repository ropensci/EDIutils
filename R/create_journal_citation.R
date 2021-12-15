#' Create journal citation
#' 
#' @param packageId (character) Data package identifier
#' @param articleDoi (character) Article DOI. Required if \code{articleUrl} is missing.
#' @param articleUrl (character) Article URL. Required if \code{articleDoi} is missing.
#' @param articleTitle (character) Article title
#' @param journalTitle (character) Journal title
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#' 
#' @return (numeric) Journal citation identifier
#'     
#' @details Creates a new journal citation entry in the EDI data repository
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' res <- create_journal_citation(
#'   packageId = "edi.17.1", 
#'   articleDoi = "https://doi.org/10.1890/11-1026.1",
#'   articleTitle = "Corridors promote fire via connectivity and edge effects",
#'   journalTitle = "Ecological Applications")
#' }
#' 
create_journal_citation <- function(packageId, 
                                    articleDoi = NULL, 
                                    articleUrl = NULL,
                                    articleTitle = NULL, 
                                    journalTitle = NULL, 
                                    env = "production") {
  validate_arguments(x = as.list(environment()))
  if (is.null(c(articleDoi, articleUrl))) {
    stop('One of "articleDoi" or "articleUrl" is required.', call. = FALSE)
  }
  # Build citation
  citation <- xml2::xml_new_document()
  xml2::xml_add_child(citation, "journalCitation")
  xml2::xml_add_child(citation, "packageId", packageId)
  if (!is.null(articleDoi)) {
    xml2::xml_add_child(citation, "articleDoi", articleDoi)
  }
  if (!is.null(articleTitle)) {
    xml2::xml_add_child(citation, "articleTitle", articleTitle)
  }
  if (!is.null(articleUrl)) {
    xml2::xml_add_child(citation, "articleUrl", articleUrl)
  }
  fname <- paste0(tempdir(), "/payload.xml")
  xml2::write_xml(citation, fname)
  on.exit(file.remove(fname))
  # Submit request
  url <- paste0(base_url(env), "/package/citation/eml")
  cookie <- bake_cookie()
  resp <- httr::POST(url, 
                     set_user_agent(), 
                     cookie, 
                     body = httr::upload_file(fname), 
                     handle = httr::handle(""))
  msg <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, msg)
  parsed <- unlist(strsplit(resp$headers$location, split = "/"))
  res <- parsed[length(parsed)]
  return(as.numeric(res))
}
