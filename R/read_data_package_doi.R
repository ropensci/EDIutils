#' Read data package Digital Object Identifier
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) The canonical Digital Object Identifier for
#' \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read package DOI
#' doi <- read_data_package_doi(packageId = "knb-lter-jrn.210548103.15")
#' doi
#' #> [1] "doi:10.6073/pasta/c80c0c03d22791524d4b870d2193c843"
#' }
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
