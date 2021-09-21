#' Update data package
#'
#' @param eml (character) Full path to an EML document
#' @param useChecksum (logical) Whether to use an existing copy of the data entities from a previous revision of the data package (see details below).
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#' 
#' @return transaction (character) Transaction identifier. Use this value with: 
#' \itemize{
#'   \item \code{check_status_update()} to see if the update has completed or if any errors occurred while processing the request
#'   \item \code{read_evaluate_report()} to read the evaluation report
#'   \item \code{read_data_package()} to obtain the data package resource map
#' }
#' 
#' @details Each data entity described in \code{eml} must be accessible to the EDI Data Repository through URLs listed in the \code{eml} at the XPath ".//physical/distribution/online/url". This URL should be static and not present the EDI Data Repository with any redirects, otherwise the data entity will not be accessible.
#'
#' @export
#' 
#' @examples 
#' path <- "/Users/me/Documents/edi.468.2.xml"
#' update_data_package(path)
#' 
#'
update_data_package <- function(eml, useChecksum = FALSE, tier = "production"){
  validate_arguments(x = as.list(environment()))
  scope <- unlist(strsplit(basename(eml), "\\."))[1]
  identifier <- unlist(strsplit(basename(eml), "\\."))[2]
  url <- paste0(url_env(tier), ".lternet.edu/package/eml/", scope, "/", identifier)
  if (useChecksum) {
    url <- paste0(url, "?useChecksum")
  }
  cookie <- bake_cookie()
  resp <- httr::PUT(url, 
                    set_user_agent(), 
                    cookie, 
                    handle = httr::handle(""), 
                    body = httr::upload_file(eml))
  httr::stop_for_status(resp)
  transaction <- httr::content(resp, as = "text", encoding = "UTF-8")
  return(transaction)
}
