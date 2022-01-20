#' List reservation identifiers
#'
#' @param scope (character) Scope of data package
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (numeric) The set of identifiers for the specified \code{scope} that
#' end users have actively reserved for future upload
#' 
#' @family Identifier Reservations
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List reservations
#' reservations <- list_reservation_identifiers(scope = "edi")
#' reservations
#' #>   [1]   11  130  131  132  142  152  154  156  158  159  161  162  171
#' #>  [14]  172  173  174  175  177  178  180  182  183  185  196  203  ...
#' }
list_reservation_identifiers <- function(scope, env = "production") {
  url <- paste0(base_url(env), "/package/reservations/eml/", scope)
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(as.numeric(text2char(res)))
}
