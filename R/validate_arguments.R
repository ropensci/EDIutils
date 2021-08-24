#' Validate arguments to EDIutils functions
#'
#' @param x (list) A named list of arguments and corresponding values.
#'     
#' @details Checks performed by this function provide user friendly warnings and error messages to make their lives simpler.
#'
validate_arguments <- function(x) {

  # entityId
  if ("entityId" %in% names(x)) {
    pattern <- "[0-9a-z]{32}"
    if (!grepl(pattern, x[["entityId"]])) {
      stop("Input 'entityId' should be a checksum value (e.g. ",
           "'fa434ccf555bc3ed47c6c593a2d9aac0').", call. = FALSE)
    }
  }
  
  # environment
  if ('environment' %in% names(x)){
    if ((tolower(x[['environment']]) != 'development') &
        (tolower(x[['environment']]) != 'staging') &
        (tolower(x[['environment']]) != 'production')){
      stop("The input argument 'environment' must be 'development', ",
           "'staging', or 'production'.", call. = FALSE)
    }
  }
  
  # fromDate
  if ("fromDate" %in% names(x)) {
    is_accpeted_format <- grepl(
      "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}T[[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}", 
      x[["fromDate"]])
    if (!is_accpeted_format) {
      stop("Input 'fromDate' is not of the format YYYY-MM-DDThh:mm:ss", 
           call. = FALSE)
    }
  }
  
  # identifier
  if ("identifier" %in% names(x)){
    is_int <- as.numeric(x[["identifier"]]) %% 1 == 0
    if (!is_int) {
      stop("Input 'identifier' is not an integer value.", call. = FALSE)
    }
  }
  
  # o (LDAP; organizational unit)
  if ("o" %in% names(x)) {
    if (!x[["o"]] %in% c("LTER", "EDI")) {
      stop("Input 'o' is not 'EDI' or 'LTER'.", call. = FALSE)
    }
  }
  
  # operating system
  if ("os" %in% names(x)){
    if (isTRUE((tolower(x[['os']]) != "win") & 
               (tolower(x[['os']]) != "mac") &
               (tolower(x[['os']]) != "lin"))){
      stop("The value of input argument 'os' is invalid.", call. = FALSE)
    }
  }
  
  # # output
  # if ("output" %in% names(x)){
  #   supported <- c("xml_document", "data.frame")
  #   if (!x[["output"]] %in% supported) {
  #     stop('Input "output" is not supported.', call. = FALSE)
  #   }
  # }
  
  # package.id
  if ("package.id" %in% names(x)){
    if (!isTRUE(stringr::str_detect(x[['package.id']],
                                    '[:alpha:]\\.[:digit:]+\\.[:digit:]+$'))){
      stop("Input argument 'package.id' appears to be malformed. ",
           "A package ID must consist of a scope, identifier, ",
           "and revision (e.g. 'edi.100.4').", call. = FALSE)
    }
  }
  
  # TODO Implement check on scope
  
  # revision
  if ('revision' %in% names(x)){
    is_int <- as.numeric(x[["revision"]]) %% 1 == 0
    if (!is_int) {
      stop("Input 'revision' is not an integer value.", call. = FALSE)
    }
  }
  
  # toDate
  if ("toDate" %in% names(x)) {
    is_accpeted_format <- grepl(
      "[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}T[[:digit:]]{2}:[[:digit:]]{2}:[[:digit:]]{2}", 
      x[["toDate"]])
    if (!is_accpeted_format) {
      stop("Input 'toDate' is not of the format YYYY-MM-DDThh:mm:ss", call. = FALSE)
    }
  }

}
