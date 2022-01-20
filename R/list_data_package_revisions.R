#' List data package revisions
#'
#' @param scope (character) Scope of data package
#' @param identifier (numeric) Identifier of data package
#' @param filter (character) Filter results by "newest" or "oldest"
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (numeric) Revisions of a data package within a specified
#' \code{scope} and \code{identifier}
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List revisions
#' revisions <- list_data_package_revisions("knb-lter-arc", 20131)
#' revisions
#' #> [1] 1 2
#' }
list_data_package_revisions <- function(scope,
                                        identifier,
                                        filter = NULL,
                                        env = "production") {
  url <- paste0(
    base_url(env), "/package/eml/",
    paste(c(scope, as.character(identifier)), collapse = "/")
  )
  if (!is.null(filter)) {
    url <- paste0(url, "?filter=", filter)
  }
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(text2char(res)))
}
