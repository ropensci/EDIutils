#' List active reservations
#'
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) The set of data package identifiers that users have
#' actively reserved. Note that data package identifiers that have been
#' successfully uploaded are no longer considered active reservations and thus
#' are not included in this list.
#' 
#' @family Identifier Reservations
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # List reservations
#' reservations <- list_active_reservations()
#' reservations
#' #> {xml_document}
#' #> <reservations>
#' #>  [1] <reservation>\n  <docid>edi.11</docid>\n  <principal>uid=NTL,o=L ...
#' #>  [2] <reservation>\n  <docid>edi.130</docid>\n  <principal>uid=user23 ...
#' #>  [3] <reservation>\n  <docid>edi.131</docid>\n  <principal>uid=user20 ...
#' #>  [4] <reservation>\n  <docid>edi.132</docid>\n  <principal>uid=chase, ...
#' #>  [5] <reservation>\n  <docid>edi.142</docid>\n  <principal>uid=ahall, ...
#' #>  [6] <reservation>\n  <docid>edi.152</docid>\n  <principal>uid=ahall, ...
#' #>  [7] <reservation>\n  <docid>edi.154</docid>\n  <principal>uid=ahall, ...
#' #>  [8] <reservation>\n  <docid>edi.156</docid>\n  <principal>uid=ahall, ...
#' #>  [9] <reservation>\n  <docid>edi.158</docid>\n  <principal>uid=ahall, ...
#' #> [10] <reservation>\n  <docid>edi.159</docid>\n  <principal>uid=ahall, ...
#' #> ...
#' 
#' # Show first
#' xml2::xml_find_first(reservations, "reservation")
#' #> {xml_node}
#' #> <reservation>
#' #> [1] <docid>edi.11</docid>
#' #> [2] <principal>uid=NTL,o=LTER,dc=ecoinformatics,dc=org</principal>
#' #> [3] <dateReserved>2017-03-02 15:02:28.899</dateReserved>
#' }
list_active_reservations <- function(env = "production") {
  url <- paste0(base_url(env), "/package/reservations/eml")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
