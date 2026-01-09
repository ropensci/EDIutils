#' Create a users distinguished name (defunct)
#' 
#' This function is defunct. Distinguished names are deprecated in favor of EDI 
#' IDs. An EDI ID can be obtained from the EDI Identity and Access 
#' Manager (\url{https://auth.edirepository.org/auth/ui/signin}).
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
  .Defunct(msg = "'create_dn()' is defunct. Distinguished names are no longer 
           used in EDI authentication. Use an EDI ID token instead.")
  ou <- toupper(ou)
  res <- paste0("uid=", userId, ",o=", ou, ",")
  if (ou == "EDI") {
    res <- paste0(res, "dc=edirepository,dc=org")
  } else {
    res <- paste0(res, "dc=ecoinformatics,dc=org")
  }
  return(res)
}
