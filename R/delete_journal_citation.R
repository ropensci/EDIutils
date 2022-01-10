#' Delete journal citation
#'
#' @param journalCitationId (numeric) Journal citation identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (logical) TRUE if deleted
#'
#' @note User authentication is required (see \code{login()})
#' 
#' @family Journal Citations
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' login()
#'
#' # Create journal citation
#' journalCitationId <- create_journal_citation(
#'   packageId = "edi.17.1",
#'   articleDoi = "https://doi.org/10.1890/11-1026.1",
#'   articleTitle = "Corridors promote fire via connectivity and edge effects",
#'   journalTitle = "Ecological Applications",
#'   relationType = "IsCitedBy",
#'   env = "staging"
#' )
#' journalCitationId
#' #> [1] 74
#'
#' # Delete journal citation
#' delete_journal_citation(journalCitationId, env = "staging")
#' #> [1] TRUE
#'
#' logout()
#' }
#'
delete_journal_citation <- function(journalCitationId, env = "production") {
  url <- paste0(
    base_url(env), "/package/citation/eml/",
    journalCitationId
  )
  cookie <- bake_cookie()
  resp <- httr::DELETE(
    url,
    set_user_agent(),
    cookie,
    handle = httr::handle("")
  )
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  if (resp$status_code == "200") {
    return(TRUE)
  } else {
    return(FALSE)
  }
}
