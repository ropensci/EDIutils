#' Read data entity sizes
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame) Size (in bytes) and identifiers of data entities in
#' \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read entity sizes
#' sizes <- read_data_entity_sizes(packageId = "knb-lter-bnz.786.3")
#' sizes
#' #>                           entityId   size
#' #> 1 66bf513405f7799c35f24e4b33f7d835  19513
#' #> 2 33d2d8cedeea9d5dbefc973680d4557e  26429
#' #> 3 197b0d4372ecabd697cfd5ff1157e41b   2295
#' #> 4 bb8cdcf1d6f06f61007620bfa5333f2a 123366
#' #> 5 0916ac12f9896c35a27ea156c653718e  46475
#' }
read_data_entity_sizes <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/data/size/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  df <- utils::read.csv(text = res, as.is = TRUE, header = FALSE)
  names(df) <- c("entityId", "size")
  return(df)
}
