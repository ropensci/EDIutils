#' List recent uploads
#'
#' @param type (character) Upload type. Can be: "insert" or "update".
#' @param limit (numeric) Maximum number of results to return
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Data package uploads
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get the 3 newest revisions
#' dataPackageUploads <- list_recent_uploads("update", 3)
#' dataPackageUploads
#' #> {xml_document}
#' #> <dataPackageUploads>
#' #> [1] <dataPackage>\n  <packageId>knb-lter-hbr.106.3</packageId>\n  <sc ...
#' #> [2] <dataPackage>\n  <packageId>knb-lter-hbr.105.3</packageId>\n  <sc ...
#' #> [3] <dataPackage>\n  <packageId>knb-lter-hbr.104.3</packageId>\n  <sc ...
#' 
#' # Show first
#' xml2::xml_find_first(dataPackageUploads, "dataPackage")
#' #> {xml_node}
#' #> <dataPackage>
#' #> [1] <packageId>knb-lter-hbr.106.3</packageId>
#' #> [2] <scope>knb-lter-hbr</scope>
#' #> [3] <identifier>106</identifier>
#' #> [4] <revision>3</revision>
#' #> [5] <principal>uid=HBR,o=EDI,dc=edirepository,dc=org</principal>
#' #> [6] <doi/>
#' #> [7] <serviceMethod>updateDataPackage</serviceMethod>
#' #> [8] <date>2022-01-17 12:49:00</date>#> 
#' }
list_recent_uploads <- function(type, limit = 5, env = "production") {
  url <- paste0(
    base_url(env), "/package/uploads/eml",
    "?type=", type, "&limit=", limit
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
