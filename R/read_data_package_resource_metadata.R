#' Read data package resource metadata
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Resource metadata of \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' # Read resource metadata
#' resourceMetadata <- read_data_package_resource_metadata(
#'   packageId = "edi.613.1"
#' )
#' resourceMetadata
read_data_package_resource_metadata <- function(packageId,
                                                env = "production") {
  url <- paste0(
    base_url(env), "/package/rmd/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
