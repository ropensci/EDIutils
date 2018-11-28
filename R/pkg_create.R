#' Create data package
#'
#' @description
#'     Create a data package in the Environmental Data Initiative repository.
#'     Use this function to create the first version of a data package. Use
#'     `pkg_update` to update a data package.
#'
#' @usage pkg_create(path, package.id, environment, user.id, user.pass,
#'     affiliation)
#'
#' @param path
#'     (character) Path to the data package EML file.
#' @param package.id
#'     (character) Package identifier composed of scope, identifier, and
#'     revision (e.g. 'edi.101.1').
#' @param environment
#'     (character) Data repository environment to create the package in.
#'     Can be: 'development', 'staging', 'production'.
#' @param user.id
#'     (character) Identification of user creating the data package.
#' @param user.pass
#'     (character) Password corresponding with the user.id argument supplied
#'     above.
#' @param affiliation
#'     (character) Affiliation corresponding with the user.id argument supplied
#'     above. Can be: 'LTER' or 'EDI'.
#'
#' @note
#'     Data described by the EML metadata record must be accessible through a
#'     URL supporting download by the EDI data repository. This URL must be
#'     supplied for each data entity in the "physical" node of the EML (i.e.
#'     //physical/distribution/online/url).
#'
#' @export
#'

pkg_create <- function(path, package.id, environment, user.id, user.pass,
                       affiliation){

  # Validate arguments --------------------------------------------------------

  if (missing(path)){
    stop('Input argument "path" is missing!')
  }
  if (missing(package.id)){
    stop('Input argument "package.id" is missing!')
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
  if (!isTRUE(stringr::str_detect(package.id,
                                  '[:alpha:]\\.[:digit:]+\\.[:digit:]'))){
    stop(paste0('Input argument "package.id" appears to be malformed.',
                'A package ID must consist of a scope, identifier, ',
                'and revision (e.g. "edi.100.4").'))
  }

  validate_path(path)

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

  # Create package ------------------------------------------------------------

  # Place request
  r <- httr::POST(
    url = paste0(url_env, '.lternet.edu/package/eml'),
    config = authenticate(key, user.pass),
    body = upload_file(paste0(path, '/', package.id, '.xml'))
  )

  # Enter polling loop
  if (r$status_code == '202'){
    transaction_id <- content(r, as = 'text', encoding = 'UTF-8')
    while (TRUE){
      Sys.sleep(2)
      r <- httr::GET(
        url = paste0(url_env, '.lternet.edu/package/error/eml/',
                     transaction_id),
        config = authenticate(key, '10qp29wo')
      )
      if (r$status_code == '200'){
        r_content <- content(r, type = 'text', encoding = 'UTF-8')
        stop(r_content)
        break
      }
      r <- httr::GET(
        url = paste0(url_env, '.lternet.edu/package/eml/',
                     stringr::str_replace_all(package.id, '\\.', '/')),
        config = authenticate(key, '10qp29wo')
      )
      if (r$status_code == '200'){
        eval_report <- readr::read_file(
          paste0(url_env, '.lternet.edu/package/report/eml/',
                 stringr::str_replace_all(package.id, '\\.', '/'))
        )
        check_status <- unlist(
          stringr::str_extract_all(eval_report, '[:alpha:]+(?=</status>)'))
        check_datetime <- unlist(
          stringr::str_extract_all(
            eval_report, '(?<=<creationDate>)[:graph:]+(?=</creationDate>)'))
        n_valid <- as.character(sum(check_status == 'valid'))
        n_warn <- as.character(sum(check_status == 'warn'))
        n_error <- as.character(sum(check_status == 'error'))
        n_info <- as.character(sum(check_status == 'info'))
        message(paste0(
          'UPLOAD RESULTS\n',
          'Package Id: ', package.id, '\n',
          'Was Uploaded: Yes\n',
          'Report: ', paste0(url_env,
                             '.lternet.edu/package/evaluate/report/eml/',
                             stringr::str_replace_all(package.id, '\\.', '/')),
          '\n',
          'Creation Date:', check_datetime, '\n',
          'Total Quality Checks: ', length(check_status), '\n',
          'Valid: ', n_valid, '\n',
          'Info: ', n_info, '\n',
          'Warn: ', n_warn, '\n',
          'Error: ', n_error, '\n'
          )
        )
        break
      }
    }
  } else {
    stop('Error creating package.')
  }

}
