#' Reserve package identifier
#'
#' @description
#'     Reserve a package identifier in the Environmental Data Initiative
#'     repository.
#'
#' @usage pkg_reserve_id(scope, environment, user.id, user.pass, affiliation)
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
#'
#' @return
#'     (character) Package identifier.
#'
#' @export
#'

pkg_reserve_id <- function(scope, environment, user.id, user.pass, affiliation){

  validate_arguments(x = as.list(environment()))

  # Place request
  r <- httr::POST(
    url = paste0(url_env(environment), '.lternet.edu/package/reservations/eml/', scope),
    config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
  )

  # Enter polling loop
  while (TRUE){
    Sys.sleep(2)
    if (r$status_code == '201'){
      reserved_pkg_id <- httr::content(r, as = 'text', encoding = 'UTF-8')
      reserved_pkg_id
      break
    } else if (r$status_code == '401'){
      stop('You are not authorized to create subscriptions.')
      break
    } else if (r$status_code == '400'){
      stop('Request entity contains an error.')
      break
    }
  }

  reserved_pkg_id

}
