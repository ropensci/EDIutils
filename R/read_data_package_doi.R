#' Read data package Digital Object Identifier
#'
#' @param packageId (character) Data package identifier
#' @param as_url (logical) Returns the DOI as a URL if TRUE.
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) The Digital Object Identifier for \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read package DOI
#' doi <- read_data_package_doi("knb-lter-jrn.210548103.15")
#' doi
#' #> [1] "doi:10.6073/pasta/c80c0c03d22791524d4b870d2193c843"
#' 
#' # Read package DOI as URL
#' doi <- read_data_package_doi("knb-lter-jrn.210548103.15", as_url = TRUE)
#' doi
#' #> [1] "https://doi.org/10.6073/pasta/c80c0c03d22791524d4b870d2193c843"
#' }
read_data_package_doi <- function(packageId, 
                                  as_url = FALSE, 
                                  env = "production") {
  url <- paste0(
    base_url(env), "/package/doi/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  res <- text2char(res)
  if (as_url) {
    res <- gsub("doi:", "", res)
    return(paste0("https://doi.org/", res))
  } else {
    return(res)
  }
}
