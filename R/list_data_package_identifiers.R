#' List data package identifiers
#'
#' @param scope (character) Data package scope (e.g. "edi", "knb-lter-bnz").
#' @param environment (character) PASTA environment to which this operation will be applied. Can be: "production", "staging", or "development".
#'
#' @return (data.frame) All identifiers within a \code{scope}
#' 
#' @details GET : https://pasta.lternet.edu/package/eml/{scope}
#'
#' @export
#' 
#' @examples
#' list_data_package_identifiers("knb-lter-ble")
#' 
list_data_package_identifiers <- function(scope, environment = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(environment), ".lternet.edu/package/eml/", scope)
  resp <- httr::GET(url, set_user_agent())
  httr::stop_for_status(resp)
  parsed <- httr::content(resp, as = "text", encoding = "UTF-8")
  browser()
  res <- read.csv(text = c("identifier", parsed), as.is = TRUE, 
                  colClasses = "character")
  return(res)
}
