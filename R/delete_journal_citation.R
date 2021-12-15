#' Delete journal citation
#'
#' @param journalCitationId (numeric) Journal citation identifier
#' @param env (character) Repository environment. Can be: "production", "staging", or "development".
#' 
#' @return (logical) TRUE if deleted
#' 
#' @note User authentication is required (see \code{login()})
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' journalCitationId <- 65
#' delete_journal_citation(journalCitationId)
#' }
#'
delete_journal_citation <- function(journalCitationId, tier = "production") {
  validate_arguments(x = as.list(environment()))
  url <- paste0(url_env(tier), ".lternet.edu/package/citation/eml/", 
                journalCitationId)
  cookie <- bake_cookie()
  resp <- httr::DELETE(url, 
                       set_user_agent(), 
                       cookie, 
                       handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  if (resp$status_code == "200") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
