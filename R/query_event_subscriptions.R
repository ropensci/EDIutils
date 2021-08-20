#' Query event subscriptions
#'
#' @description Query Event Subscriptions operation, returns a list of the subscriptions whose attributes match those specified in the query string. If a query string is omitted, all subscriptions in the subscription database will be returned for which the requesting user is authorized to read. If query parameters are included, they are used to filter that set of subscriptions based on their attributes.
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
#' @details GET : https://pasta.lternet.edu/package/event/eml
#' @export
#' @examples 
#'
query_event_subscriptions <- function(scope, environment, user.id, user.pass, affiliation){

  validate_arguments(x = as.list(environment()))

  poll_pkg_reserve_id(
    httr::POST(
      url = paste0(url_env(environment), 
                   '.lternet.edu/package/reservations/eml/', scope),
      config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
    )
  )

}