#' Read data package error
#'
#' @param transaction (character) Transaction identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return An error is returned if an error occurred while processing the
#' request, otherwise \code{NULL} is returned if no error was encountered or if
#' processing is still underway.
#'
#' @note User authentication is required (see \code{login()})
#' 
#' @family Accessing
#'
#' @export
#'
read_data_package_error <- function(transaction, env = "production") {
  if (grepl("__", transaction)) {
    transaction <- unlist(strsplit(transaction, "__"))[1]
  }
  url <- paste0(base_url(env), "/package/error/eml/", transaction)
  cookie <- bake_cookie()
  resp <- httr::GET(url, set_user_agent(), cookie, handle = httr::handle(""))
  if (resp$status_code %in% c("200", "400", "401", "405", "500")) {
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    stop(res, call. = FALSE)
  }
}
