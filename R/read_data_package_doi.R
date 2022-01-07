#' Read data package Digital Object Identifier
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) The canonical Digital Object Identifier for
#' \code{packageId}
#'
#' @export
#'
#' @examples
#' # Read package DOI
#' doi <- read_data_package_doi(packageId = "knb-lter-jrn.210548103.15")
#' doi
read_data_package_doi <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/doi/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
