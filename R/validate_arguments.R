#' Validate arguments to EDIutils functions
#'
#' @param x (list) A named list of arguments and corresponding values.
#'     
#' @details Checks performed by this function provide user friendly warnings and error messages to make their lives simpler.
#'
validate_arguments <- function(x) {

  # package.id
  if ('package.id' %in% names(x)){
    if (!isTRUE(stringr::str_detect(x[['package.id']],
                                    '[:alpha:]\\.[:digit:]+\\.[:digit:]+$'))){
      stop(paste0('Input argument "package.id" appears to be malformed. ',
                  'A package ID must consist of a scope, identifier, ',
                  'and revision (e.g. "edi.100.4").'))
    }
  }
  
  # identifier
  if ('identifier' %in% names(x)){
    is_int <- as.numeric(x[["identifier"]]) %% 1 == 0
    if (!is_int) {
      stop('Input "identifier" is not an integer value.', call. = FALSE)
    }
  }
  
  # revision
  if ('revision' %in% names(x)){
    is_int <- as.numeric(x[["revision"]]) %% 1 == 0
    if (!is_int) {
      stop('Input "revision" is not an integer value.', call. = FALSE)
    }
  }
  
  # environment
  if ('environment' %in% names(x)){
    if ((tolower(x[['environment']]) != 'development') &
        (tolower(x[['environment']]) != 'staging') &
        (tolower(x[['environment']]) != 'production')){
      stop(paste0('The input argument "environment" must be "development", ',
                  '"staging", or "production".'))
    }
  }
  
  # # output
  # if ("output" %in% names(x)){
  #   supported <- c("xml_document", "data.frame")
  #   if (!x[["output"]] %in% supported) {
  #     stop('Input "output" is not supported.', call. = FALSE)
  #   }
  # }

  # operating system
  if ('os' %in% names(x)){
    if (isTRUE((tolower(x[['os']]) != "win") & 
               (tolower(x[['os']]) != "mac") &
               (tolower(x[['os']]) != "lin"))){
      stop('The value of input argument "os" is invalid.')
    }
  }

}
