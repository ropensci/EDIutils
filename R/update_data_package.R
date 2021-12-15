#' Update data package
#'
#' @param eml (character) Full path to an EML file describing the data package to be updated
#' @param useChecksum (logical) Use data entities from a previous version of the data package? See details below.
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#' 
#' @return transaction (character) Transaction identifier. May be used in a subsequent call to:
#' \itemize{
#'   \item \code{check_status_update()} to determine the operation status
#'   \item \code{read_data_package()} to obtain the data package resource map
#' }
#' 
#' @details Each data entity described in \code{eml} must be accompanied by a web accessible URL at the XPath ".//physical/distribution/online/url". The EDI data repository uses these links to download the data entities. The URLs must be static and not have any redirects otherwise the data entities will not be downloadable.
#' 
#' @note User authentication is required (see \code{login()})
#'
#' @export
#' 
#' @examples 
#' path <- "/Users/me/Documents/edi.468.2.xml"
#' update_data_package(path)
#' 
#'
update_data_package <- function(eml, useChecksum = FALSE, env = "production"){
  validate_arguments(x = as.list(environment()))
  scope <- unlist(strsplit(basename(eml), "\\."))[1]
  identifier <- unlist(strsplit(basename(eml), "\\."))[2]
  url <- paste0(base_url(env), "/package/eml/", scope, "/", identifier)
  if (useChecksum) {
    url <- paste0(url, "?useChecksum")
  }
  cookie <- bake_cookie()
  resp <- httr::PUT(url, 
                    set_user_agent(), 
                    cookie, 
                    handle = httr::handle(""), 
                    body = httr::upload_file(eml))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(res)
}
