#' Check status of data package evaluation
#'
#' @param transaction (character) Transaction identifier
#' @param wait (logical) Wait for evaluation to complete? See details below.
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#'
#' @return (logical) TRUE if evaluation has completed, FALSE if in progress, and error if an error was encountered while processing the request
#' 
#' @details If \code{wait = TRUE}, then the function will enter a "while" loop checking every 2 seconds for the completed evaluation report. If \code{wait = FALSE}, then the function will only check once and return the result.
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' login()
#' 
#' # Evaluate data package
#' eml <- "./data/edi.595.1.xml"
#' transaction <- evaluate_data_package(eml, env = "staging")
#' 
#' # Check evaluation status
#' status <- check_status_evaluate(transaction, env = "staging")
#' status
#' #> [1] TRUE
#' 
#' logout()
#' }
#'
check_status_evaluate <- function(transaction, wait = TRUE, env = "production") {
  if (wait) {
    while (TRUE) {
      Sys.sleep(2)
      read_data_package_error(transaction, env)
      url = paste0(base_url(env), "/package/evaluate/report/eml/",
                   transaction)
      cookie <- bake_cookie()
      resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
      res <- httr::content(resp, as = "text", encoding = "UTF-8")
      httr::stop_for_status(resp, res)
      if (resp$status == "200") {
        return(TRUE)
      } else {
        return(FALSE)
      }
    }
  } else {
    read_data_package_error(transaction, env)
    url = paste0(base_url(env), "/package/evaluate/report/eml/",
                 transaction)
    cookie <- bake_cookie()
    resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    if (resp$status == "200") {
      return(TRUE)
    } else {
      return(FALSE)
    }
  }
}
