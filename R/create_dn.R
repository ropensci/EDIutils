#' Create a users distinguished name
#'
#' @param userId (character) User identifier of an EDI data repository account
#' @param ou (character) Organizational unit in which \code{userId} belongs.
#' Can be "EDI" or "LTER". All \code{userId} issued after "2020-05-01" have
#' \code{ou = "EDI"}.
#'
#' @return (character) Distinguished name
#' 
#' @family Miscellaneous
#'
#' @export
#'
#' @examples
#' # For an EDI account
#' dn <- create_dn(userId = "my_userid", ou = "EDI")
#' dn
#'
#' # For an LTER account
#' dn <- create_dn(userId = "my_userid", ou = "LTER")
#' dn
create_dn <- function(userId, ou = "EDI") {
  ou <- toupper(ou)
  res <- paste0("uid=", userId, ",o=", ou, ",")
  if (ou == "EDI") {
    res <- paste0(res, "dc=edirepository,dc=org")
  } else {
    res <- paste0(res, "dc=ecoinformatics,dc=org")
  }
  return(res)
}
