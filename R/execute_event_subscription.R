#' Execute event subscription
#'
#' @description Execute Event Subscription operation, specifying the ID of the event subscription whose URL is to be executed. Used to execute a particular subscription in the event manager, via an HTTP POST request. Upon notification, the event manager queries its database for the subscription matching the specified subscriptionId. POST requests are then made (asynchronously) to the matching subscription.
#' 
#' The request headers must contain an authorization token. If the request is successful, an HTTP response with status code 200 ‘OK’ is returned. If the request is unauthorized, based on the content of the authorization token and the current access control rule for event notification, status code 401 ‘Unauthorized’ is returned. If the request contains an error, status code 400 ‘Bad Request’ is returned, with a description of the encountered error.
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
#' @details POST : https://pasta.lternet.edu/package/event/eml/{subscriptionId}
#' @export
#' @examples 
#'
execute_event_subscription <- function(scope, environment, user.id, user.pass, affiliation){

  validate_arguments(x = as.list(environment()))

  poll_pkg_reserve_id(
    httr::POST(
      url = paste0(url_env(environment), 
                   '.lternet.edu/package/reservations/eml/', scope),
      config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
    )
  )

}