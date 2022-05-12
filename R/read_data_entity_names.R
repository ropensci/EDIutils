#' Read data entity names
#'
#' @param packageId (character) Data package identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (data.frame) Names and identifiers of all data entities in
#' \code{packageId}
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' read_data_entity_names("knb-lter-cap.691.2")
#' #>                           entityId
#' #> 1 f6e4efd0b04aea3860724824ca05c5dd
#' #> 2 d2263480e75cc7888b41928602cda4c6
#' #> 3 d5cb83e4556408e48f636157e4dee49e
#' #>                                                 entityName
#' #> 1      691_arthropods_00742cd00ab0d3d02337e28d1c919654.csv
#' #> 2        691_captures_e5f57a98ae0b7941b10d4a600645495a.csv
#' #> 3 691_sampling_events_e8d76d7e76385e4ae84bcafb754d0093.csv
#' }
read_data_entity_names <- function(packageId, env = "production") {
  url <- paste0(
    base_url(env), "/package/name/eml/",
    paste(parse_packageId(packageId), collapse = "/")
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  
  # PASTA uses commas as a field delimiter, which results in parsing issues if
  # an entity name contains commas. So fix here until fixed in PASTA.
  res <- unlist(strsplit(res, "\\n"))
  dlim <- "\\|\\|\\|"
  res <- strsplit(sub(",\\s*", dlim, res), dlim)
  df <- data.frame(do.call(rbind, res))
  
  names(df) <- c("entityId", "entityName")
  return(df)
}
