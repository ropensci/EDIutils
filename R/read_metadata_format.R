#' Read metadata format
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) Metadata format type
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read format
#' metadataFormat <- read_metadata_format("knb-lter-nwt.930.1")
#' metadataFormat
#' #> [1] "eml://ecoinformatics.org/eml-2.1.1"
#' }
read_metadata_format <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/metadata/format/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
