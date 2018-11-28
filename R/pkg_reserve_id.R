#' Reserve package identifier
#'
#' @description
#'     Reserve a package identifier in the Environmental Data Initiative
#'     repository.
#'
#' @usage pkg_reserve_id(environment, user.id, user.pass, affiliation)
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

  # Validate arguments --------------------------------------------------------

  if (missing(scope)){
    stop('Input argument "scope" is missing!')
  }
  if (missing(environment)){
    stop('Input argument "environment" is missing!')
  }
  if (missing(user.id)){
    stop('Input argument "user.id" is missing!')
  }
  if (missing(user.pass)){
    stop('Input argument "user.pass" is missing!')
  }
  if (missing(affiliation)){
    stop('Input argument "affiliation" is missing!')
  }

  affiliation <- tolower(affiliation)
  if ((affiliation != 'lter') & (affiliation != 'edi')){
    stop('The input argument "affiliation" must be "lter" or "edi".')
  }

  environment <- tolower(environment)
  if ((environment != 'development') & (environment != 'staging') &
      (environment != 'production')){
    stop(paste0('The input argument "environment" must be "development", ',
                '"staging", or "production".'))
  }

  # Parameterize --------------------------------------------------------------

  # Build URLS
  if (environment == 'development'){
    url_env <- 'https://pasta-d'
  } else if (environment == 'staging'){
    url_env <- 'https://pasta-s'
  } else if (environment == 'production'){
    url_env <- 'https://pasta'
  }

  # Build authentication key
  if (affiliation == 'lter'){
    key <- paste0('uid=', user.id, ',o=LTER',
                  ',dc=ecoinformatics,dc=org')
  } else if (affiliation == 'edi'){
    key <- paste0('uid=', user.id, ',o=EDI',
                  ',dc=edirepository,dc=org')
  }

  # Reserve package identifier ------------------------------------------------

  # Place request
  r <- httr::POST(
    url = paste0(url_env, '.lternet.edu/package/reservations/eml/', scope),
    config = authenticate(key, user.pass)
  )

  # Enter polling loop
  while (TRUE){
    Sys.sleep(2)
    if (r$status_code == '201'){
      reserved_pkg_id <- content(r, as = 'text', encoding = 'UTF-8')
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
