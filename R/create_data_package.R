#' Create data package
#'
#' @param eml (character) Full path to an EML file describing the data package to be created
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#' 
#' @return transaction (character) Transaction identifier. May be used in a subsequent call to:
#' \itemize{
#'   \item \code{check_status_create()} to determine the operation status
#'   \item \code{read_data_package()} to obtain the data package resource map
#' }
#' 
#' @details Each data entity described in \code{eml} must be accompanied by a web accessible URL at the EML XPath ".//physical/distribution/online/url". The EDI data repository downloads the data entities via this URL. The URLs must be static and not have any redirects otherwise the data entities will not be downloaded.
#' 
#' @note User authentication is required (see \code{login()})
#'
#' @export
#' 
#' @examples 
#' \dontrun{
#' path <- "/Users/me/Documents/edi.468.1.xml"
#' create_data_package(path)
#' }
#'
create_data_package <- function(eml, env = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(env), ".lternet.edu/package/eml")
  cookie <- bake_cookie()
  resp <- httr::POST(url, 
                     set_user_agent(), 
                     cookie, 
                     handle = httr::handle(""), 
                     body = httr::upload_file(eml))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(res)
}
