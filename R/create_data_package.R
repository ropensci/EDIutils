#' Create data package
#'
#' @param eml (character) Full path to an EML file
#' @param tier (character) Repository tier. Can be: "production", "staging", or "development".
#' 
#' @return transaction (character) Transaction identifier. Use this value with: 
#' \itemize{
#'   \item \code{check_status_create()} to see if creation has completed or if any errors occurred while processing the request
#'   \item \code{read_evaluate_report()} to read the evaluation report
#'   \item \code{read_data_package()} to obtain the data package resource map
#' }
#' 
#' @details Each data entity described in \code{eml} must be accessible to the EDI Data Repository through URLs listed in the \code{eml} at the XPath ".//physical/distribution/online/url". This URL should be static and not present the EDI Data Repository with any redirects, otherwise the data entity will not be accessible.
#'
#' @export
#' 
#' @examples 
#' \dontrun{
#' path <- "/Users/me/Documents/edi.468.1.xml"
#' create_data_package(path)
#' }
#'
create_data_package <- function(eml, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/eml")
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
