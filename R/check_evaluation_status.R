#' Check data package evaluation status
#'
#' @param transaction (character) Transaction identifier
#' @param tier (character) Repository tier, which can be: "production", "staging", or "development"
#'
#' @return (list) A list containing:
#' \itemize{
#'   \item "evaluated" (logical) TRUE if evaluation has completed and the report is available
#'   \item "response" (response) Response from status check on \code{transaction}
#' }
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' path <- "/Users/me/Documents/edi.468.1.xml"
#' transaction <- evaluate_data_package(path)
#' check_evaluation_status(transaction)
#' }
#'
check_evaluation_status <- function(transaction, tier = "production") {
  cookie <- bake_cookie()
  while (TRUE) {
    Sys.sleep(2)
    url = paste0(url_env(tier), ".lternet.edu/package/evaluate/report/eml/",
                 transaction)
    resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
    if (resp$status == "200") {
      res <- resp
      break
    } else {
      status <- tryCatch({httr::stop_for_status(resp)},
                         error = function(cond) {return("error")})
      if (status == "error") {
        res <- resp
        break
      }
    }
  }
  if (res$status == "200") {
    return(list(evaluated = TRUE, response = res))
  } else {
    httr::warn_for_status(res)
    return(list(evaluated = FALSE, response = res))
  }
}