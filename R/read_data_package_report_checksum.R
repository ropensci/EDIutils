#' Read data package report checksum
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) A 40 character SHA-1 checksum value for the report
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read report checksum
#' packageId <- "knb-lter-luq.208.1"
#' checksum <- read_data_package_report_checksum(packageId)
#' checksum
#' #> "980dbf3f3cdb7395933b711b005722033bdcd12f"
#' }
read_data_package_report_checksum <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/report/checksum/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
