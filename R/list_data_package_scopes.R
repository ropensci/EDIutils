#' List data package scopes
#'
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (numeric) Scopes within a specified \code{env}
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List scopes
#' scopes <- list_data_package_scopes()
#' scopes
#' #>  [1] "ecotrends"           "edi"                 "knb-lter-and"       
#' #>  [4] "knb-lter-arc"        "knb-lter-bes"        "knb-lter-ble"       
#' #>  [7] "knb-lter-bnz"        "knb-lter-cap"        "knb-lter-cce"       
#' #> [10] "knb-lter-cdr"        "knb-lter-cwt"        "knb-lter-fce"       
#' #> [13] "knb-lter-gce"        "knb-lter-hbr"        "knb-lter-hfr"       
#' #> [16] "knb-lter-jrn"        "knb-lter-kbs"        "knb-lter-knz"       
#' #> [19] "knb-lter-luq"        "knb-lter-mcm"        "knb-lter-mcr"       
#' #> [22] "knb-lter-nes"        "knb-lter-nin"        "knb-lter-ntl"       
#' #> [25] "knb-lter-nwk"        "knb-lter-nwt"        "knb-lter-pal"       
#' #> [28] "knb-lter-pie"        "knb-lter-sbc"        "knb-lter-sev"       
#' #> [31] "knb-lter-sgs"        "knb-lter-vcr"        "lter-landsat"       
#' #> [34] "lter-landsat-ledaps" "msb-cap"             "msb-paleon"         
#' #> [37] "msb-tempbiodev"   
#' }
list_data_package_scopes <- function(env = "production") {
  url <- paste0(base_url(env), "/package/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
