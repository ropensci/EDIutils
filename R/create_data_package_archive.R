#' Create data package archive (zip)
#' 
#' This function is DEPRECATED.
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return transaction (character) Transaction identifier.
#' 
#' @family Miscellaneous
#'
#' @export
#'
create_data_package_archive <- function(packageId, env = "production") {
  .Deprecated(msg = "The 'create_data_package_archive' function is deprecated.")
  url <- paste0(
    base_url(env), "/package/archive/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::POST(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(res)
}
