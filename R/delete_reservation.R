#' Delete reservation
#'
#' @description Delete Reservation operation, deletes an existing reservation from PASTA. The same user who originally authenticated to create the reservation must authenticate to delete it, otherwise a “401 Unauthorized” response is returned. When successfully deleted, a “200 OK” response is returned, and the integer value of the deleted reservation identifier value is returned in the web service response body.
#'
#' @param scope
#'     (character) Scope of identifier to be reserved (e.g. edi, knb-lter-ntl).
#' @param environment
#'     (character) Data repository environment in which to reserve the
#'     identifier. Can be: 'development', 'staging', 'production'.
#' @param user.id
#'     (character) Identification of user reserving the identifier.
#' @param user.pass
#'     (character) Password corresponding with the user.id argument supplied
#'     above.
#' @param affiliation
#'     (character) Affiliation corresponding with the user.id argument supplied
#'     above. Can be: 'LTER' or 'EDI'.
#' @details DELETE : https://pasta.lternet.edu/package/reservations/eml/{scope}/{identifier}
#' @return
#'     (character) Package identifier.
#' @export
#' @examples 
#' # Using curl to delete an existing reservation for scope (“edi”) and identifier (“12”):
#'
delete_reservation <- function(scope, environment, user.id, user.pass, affiliation){

  validate_arguments(x = as.list(environment()))

  poll_pkg_reserve_id(
    httr::POST(
      url = paste0(url_env(environment), 
                   '.lternet.edu/package/reservations/eml/', scope),
      config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
    )
  )

}