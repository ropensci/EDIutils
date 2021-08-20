#' Create reservation
#'
#' @description Create Reservation operation, creates a new reservation in PASTA for the specified user on the next reservable identifier for the specified scope. The integer value of the reserved identifier (as assigned by PASTA) is returned in the web service response body. User authentication is required.
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
#' @details POST : https://pasta.lternet.edu/package/reservations/eml/{scope}
#' @return
#'     (character) Package identifier.
#' @export
#' @examples 
#' # Using curl to reserve the next available identifier for the specified scope (“edi”):
#'
create_reservation <- function(scope, environment, user.id, user.pass, affiliation){

  validate_arguments(x = as.list(environment()))

  poll_pkg_reserve_id(
    httr::POST(
      url = paste0(url_env(environment), 
                   '.lternet.edu/package/reservations/eml/', scope),
      config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
    )
  )

}