#' Validate arguments to EDIutils functions
#'
#' @param x (list) A named list of arguments and corresponding values.
#'     
#' @details Checks performed by this function provide user friendly warnings and error messages to make their lives simpler.
#'
validate_arguments <- function(x) {

  # TODO articleDoi
  
  # TODO articleUrl
  
  # TODO articleTitle
  
  # config
  if ("config" %in% names(x)) {
    if (!is.null(x[["config"]])) {
      txt <- readLines(x[["config"]], warn = FALSE)
      pattern <- "(?<==).*"
      i <- grepl("userId", txt)
      name <- trimws(regmatches(txt[i], regexpr(pattern, txt[i], perl = TRUE)))
      if (length(name) == 0) {
        stop("Cannot parse 'userId' from config.txt.", call. = FALSE)
      }
      i <- grepl("userPass", txt)
      pass <- trimws(regmatches(txt[i], regexpr(pattern, txt[i], perl = TRUE)))
      if (length(name) == 0) {
        stop("Cannot parse 'userPass' from config.txt.", call. = FALSE)
      }
    }
  }
  
  # doi
  if ("doi" %in% names(x)) {
    parts <- unlist(strsplit(x[["doi"]], "/"))
    valid_shoulder <- parts[1] == "doi:10.6073"
    valid_mid <- parts[2] == "pasta"
    valid_md5 <- grepl("[0-9a-z]{32}", parts[3])
    if (!all(valid_shoulder, valid_mid, valid_md5)) {
      stop("Input 'doi' should have the form 'shoulder/pasta/md5' (e.g. ",
           "'doi:10.6073/pasta/b202c11db7c64943f6b4ed9f8c17fb25')",
           call. = FALSE)
    }
  }
  
  # TODO Implement check on eml
  
  # entityId
  if ("entityId" %in% names(x)) {
    pattern <- "[0-9a-z]{32}"
    if (!grepl(pattern, x[["entityId"]])) {
      stop("Input 'entityId' should be a checksum value (e.g. ",
           "'fa434ccf555bc3ed47c6c593a2d9aac0').", call. = FALSE)
    }
  }
  
  # filter
  if ("filter" %in% names(x)) {
    if (!is.null(x[["filter"]])) {
      if (!x[["filter"]] %in% c("newest", "oldest")) {
        stop("Input 'filter' must be 'newest' or 'oldest'", call. = FALSE)
      }
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
  
  # html
  if ("html" %in% names(x)) {
    if (!is.logical(x[["html"]])) {
      stop("Input 'html' should be of class 'logical'", call. = FALSE)
    }
  }
  
  # identifier
  if ("identifier" %in% names(x)){
    is_int <- as.numeric(x[["identifier"]]) %% 1 == 0
    if (!is_int) {
      stop("Input 'identifier' is not an integer value.", call. = FALSE)
    }
  }
  
  # TODO Implement check on journalCitationId
  
  # TODO journalTitle
  
  # o (LDAP; organizational unit)
  if ("o" %in% names(x)) {
    if (!x[["o"]] %in% c("LTER", "EDI")) {
      stop("Input 'o' is not 'EDI' or 'LTER'.", call. = FALSE)
    }
  }
  
  # ore
  if ("ore" %in% names(x)) {
    if (!is.logical(x[["ore"]])) {
      stop("Input 'ore' must be logical.", call. = FALSE)
    }
  }
  
  # operating system
  if ("os" %in% names(x)){
    if ((tolower(x[['os']]) != "win") & 
        (tolower(x[['os']]) != "mac") &
        (tolower(x[['os']]) != "lin")) {
      stop("The value of input argument 'os' is invalid.", call. = FALSE)
    }
  }
  
  # TODO Use output arg?
  # # output
  # if ("output" %in% names(x)){
  #   supported <- c("xml_document", "data.frame")
  #   if (!x[["output"]] %in% supported) {
  #     stop('Input "output" is not supported.', call. = FALSE)
  #   }
  # }
  
  # package.id
  if ("package.id" %in% names(x)){
    if (!stringr::str_detect(x[['package.id']],
                                    '[:alpha:]\\.[:digit:]+\\.[:digit:]+$')) {
      stop("Input argument 'package.id' appears to be malformed. ",
           "A package ID must consist of a scope, identifier, ",
           "and revision (e.g. 'edi.100.4').", call. = FALSE)
    }
  }
  
  # TODO Implement check on query
  
  # TODO Implement check on resourceId
  
  
  # revision
  if ('revision' %in% names(x)){
    is_int <- as.numeric(x[["revision"]]) %% 1 == 0
    if (!is_int) {
      stop("Input 'revision' is not an integer value.", call. = FALSE)
    }
  }
  
  # TODO Implement check on scope
  
  # tier
  if ('tier' %in% names(x)){
    if ((tolower(x[['tier']]) != 'development') &
        (tolower(x[['tier']]) != 'staging') &
        (tolower(x[['tier']]) != 'production')){
      stop("The input argument 'tier' must be 'development', ",
           "'staging', or 'production'.", call. = FALSE)
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
  
  # TODO implement check on transaction identifier
  
  # TODO url

}
