#' Generate a URL for a pre-populated tweet
#'
#' @param packageId
#'     (character) The full package identifier (scope, accession, revision) of an EDI Data Package in the PASTA production environment 
#' @param text 
#'     (character) The text for the tweet to be generated
#'
#' @return A URL for a pre-populated tweet that links to a data package and tags EDI's twitter account
#'
#' @examples
#' 
#' template_tweet('edi.101.1', "See our recent data package publication!")
#' 
#' @export
#' 
template_tweet <- function(packageId, text) {
  
  base_tweet <- "https://twitter.com/intent/tweet?text="
  
  url <- paste0("https://portal.edirepository.org/nis/mapbrowse?scope=",
                parse_packageId(packageId)[[1]], "&identifier=",
                parse_packageId(packageId)[[2]])
  
  tweet <- paste0(text, '\n\n', url,
                  "\n\n@EDIgotdata")
  
  if(nchar(tweet) > 280) warning("Your tweet is longer than 280 characters", call. = FALSE)
  
                  
  paste0(base_tweet, RCurl::curlEscape(tweet))
  
}

