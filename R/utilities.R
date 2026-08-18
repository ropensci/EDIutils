#' Create authentication cookie for EDI repository Gatekeeper
#'
#' @return (request) The request object returned by \code{httr::set_cookies()}
#' with the EDI repository authentication token baked in. Yum!
#'
#' @noRd
#'
bake_cookie <- function() {
  edi_token <- Sys.getenv("EDI_TOKEN")
  has_key <- Sys.getenv("EDI_API_KEY") != "" && Sys.getenv("EDI_API_KEY") != "foobar"
  try(auth_token <- Sys.getenv("AUTH_TOKEN"), silent = TRUE)  # facilitates deprecation of the "auth-token"
  
  if (has_key && (edi_token == "" || edi_token == "foobar")) {
    return(httr::config())
  }
  
  if (edi_token == "") {
    stop("Authentication token not found. Run 'login()' then try again.",
      call. = FALSE
    )
  }
  cookie <- httr::set_cookies(
    `edi-token` = edi_token,
    `auth-token` = auth_token # can be removed after deprecation of "auth-token" 
    )
  cookie$options$cookie <- curl::curl_unescape(cookie$options$cookie)
  return(cookie)
}








#' Construct base URL of the EDI repository web services
#'
#' @param env (character) Data repository environment to perform the evaluation
#' in. Can be: 'development', 'staging', 'production'.
#'
#' @return (character) Base url
#'
#' @noRd
#'
base_url <- function(env) {
  env <- tolower(env)
  if (env == "development") {
    res <- "https://pasta-d.lternet.edu"
  } else if (env == "staging") {
    res <- "https://pasta-s.lternet.edu"
  } else if (env == "production") {
    res <- "https://pasta.lternet.edu"
  }
  return(res)
}








#' Construct base URL of the EDI repository data portal
#'
#' @param env (character) Data repository environment to perform the evaluation
#' in. Can be: 'development', 'staging', 'production'.
#'
#' @return (character) Base url
#'
#' @noRd
#'
base_url_portal <- function(env) {
  env <- tolower(env)
  if (env == "development") {
    res <- "https://portal-d.edirepository.org"
  } else if (env == "staging") {
    res <- "https://portal-s.edirepository.org"
  } else if (env == "production") {
    res <- "https://portal.edirepository.org"
  }
  return(res)
}










#' Parse package ID into scope, identifier, and revision
#'
#' @param package.id (character) Data packageId
#'
#' @return (list) Data package scope, identifier, and revision
#'
#' @noRd
#'
parse_packageId <- function(package.id) {
  parts <- unlist(strsplit(package.id, ".", fixed = TRUE))
  res <- list(scope = parts[1], id = parts[2], rev = parts[3])
  return(res)
}








#' Read data package landing page URL
#'
#' @param packageId (character) Package identifier, of the form
#' "scope.identifier.revision", for the new EML file
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) URL of \code{packageId} landing page in the EDI
#' repository data portal
#'
#' @noRd
#'
read_data_package_landing_page_url <- function(packageId, env = "production") {
  parts <- parse_packageId(packageId)
  res <- paste0(
    base_url_portal(env), "/nis/mapbrowse?scope=", parts$scope,
    "&identifier=", parts$id, "&revision=", parts$rev
  )
  return(res)
}








#' Parse the evaluate quality report to a character string
#'
#' @param qualityReport (xml_document) Evaluate quality report document
#' @param full (logical) Return the full report if TRUE, otherwise return only
#' warnings and errors.
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) A parsed evaluate quality report
#'
#' @details A utility function for \code{read_evaluate_report()} and
#' \code{summarize_evalute_report()}
#'
#' @note User authentication is required (see \code{login()})
#'
#' @noRd
#'
report2char <- function(qualityReport, full = TRUE, env) {
  xml2::xml_ns_strip(qualityReport)

  # A helper for summarizing the report
  parse_summary <- function(qualityReport) {
    status <- xml2::xml_text(xml2::xml_find_all(qualityReport, ".//status"))
    n_valid <- sum(status == "valid")
    n_warn <- sum(status == "warn")
    n_error <- sum(status == "error")
    n_info <- sum(status == "info")
    creation_date <- xml2::xml_text(
      xml2::xml_find_first(qualityReport, ".//creationDate")
    )
    package_id <- xml2::xml_text(
      xml2::xml_find_first(qualityReport, ".//packageId")
    )
    res <- paste0(
      "\n===================================================\n",
      " EVALUATION REPORT\n",
      "===================================================\n\n",
      "PackageId: ", package_id, "\n",
      "Report Date/Time: ", creation_date, "\n",
      "Total Quality Checks: ", length(status), "\n",
      "Valid: ", n_valid, "\n",
      "Info: ", n_info, "\n",
      "Warn: ", n_warn, "\n",
      "Error: ", n_error, "\n\n"
    )
    return(res)
  }

  # A helper for parsing quality checks
  parse_check <- function(check) {
    children <- xml2::xml_children(check)
    nms <- xml2::xml_name(children) # names
    values <- xml2::xml_text(children)
    descs <- paste0(toupper(nms), ": ", values) # descriptions
    res <- paste0(paste(descs, collapse = "\n"), "\n")
    return(res)
  }

  # A helper for parsing reports (dataset & entity)
  parse_report <- function(report) {
    entity_name <- xml2::xml_text(xml2::xml_find_all(report, "entityName"))
    if (length(entity_name) > 0) {
      header <- paste0(
        "---------------------------------------------------\n",
        " ENTITY REPORT: ", entity_name, "\n",
        "---------------------------------------------------\n"
      )
    } else {
      header <- paste0(
        "---------------------------------------------------\n",
        " DATASET REPORT\n",
        "---------------------------------------------------\n"
      )
    }
    checks <- xml2::xml_find_all(report, ".//qualityCheck")
    parsed <- lapply(checks, parse_check)
    if (length(parsed) > 0) {
      res <- paste0(paste(c(header, parsed), collapse = "\n"), "\n")
      return(res)
    } else {
      return("")
    }
  }

  # Summarize, then remove any unwanted nodes
  overview <- parse_summary(qualityReport)
  checks <- xml2::xml_find_all(qualityReport, ".//qualityCheck")
  status <- xml2::xml_find_all(qualityReport, ".//status")
  if (full == FALSE) {
    i <- xml2::xml_text(status) %in% c("warn", "error")
    xml2::xml_remove(checks[!i])
  }

  # Parse reports, combine, and return
  dataset_report <- xml2::xml_find_all(qualityReport, ".//datasetReport")
  dataset_report <- lapply(dataset_report, parse_report)
  entity_reports <- xml2::xml_find_all(qualityReport, ".//entityReport")
  entity_reports <- lapply(entity_reports, parse_report)
  res <- c(overview, dataset_report, entity_reports)
  return(as.character(res))
}








#' Set EDIutils user agent for http requests
#'
#' @return (request) EDIutils user agent
#'
#' @noRd
#'
set_user_agent <- function() {
  res <- httr::user_agent("https://github.com/ropensci/EDIutils")
  return(res)
}


#' Check if a vcr cassette is actively replaying
#'
#' @return (logical) TRUE if a vcr cassette is active and we are in playback mode.
#'
#' @noRd
#'
is_vcr_replaying <- function() {
  if (requireNamespace("vcr", quietly = TRUE)) {
    cass <- vcr::current_cassette()
    if (!is.null(cass)) {
      return(cass$replaying())
    }
  }
  return(FALSE)
}


#' Append API key to URL if present
#'
#' @param url (character) The URL to modify
#'
#' @return (character) The modified URL with the "key" query parameter appended
#' if the EDI_API_KEY environment variable is set.
#'
#' @noRd
#'
add_api_key <- function(url) {
  key <- Sys.getenv("EDI_API_KEY")
  if (key == "") {
    return(url)
  }
  
  if (is_vcr_replaying()) {
    return(url)
  }
  
  if (grepl("\\?", url)) {
    if (!grepl("([?&])key=", url)) {
      url <- paste0(url, "&key=", key)
    }
  } else {
    url <- paste0(url, "?key=", key)
  }
  return(url)
}

#' Internal API request wrappers
#' @noRd
api_get <- function(url, ...) {
  url <- add_api_key(url)
  httr::GET(url, ...)
}

#' @noRd
api_post <- function(url, ...) {
  url <- add_api_key(url)
  httr::POST(url, ...)
}

#' @noRd
api_put <- function(url, ...) {
  url <- add_api_key(url)
  httr::PUT(url, ...)
}

#' @noRd
api_delete <- function(url, ...) {
  url <- add_api_key(url)
  httr::DELETE(url, ...)
}







#' Convert newline separated text to character vector
#'
#' @param txt (character) New line separated character string returned from
#' \code{httr::content(resp, as = "text", encoding = "UTF-8")}
#'
#' @return (character) \code{txt} converted to character vector
#'
#' @noRd
#'
text2char <- function(txt) {
  res <- utils::read.csv(
    text = txt,
    as.is = TRUE,
    colClasses = "character",
    header = FALSE
  )[[1]]
  return(res)
}








#' Convert xml to data.frame
#'
#' @param xml (xml_document) XML document returned by \code{xml2::read_xml()}
#'
#' @return (data.frame) \code{xml} as a data.frame
#' 
#' @note Only supports XML documents with one or two layers of nesting.
#' 
#' @noRd
#' 
xml2df <- function(xml) {
  node2df <- function(x) {
    chldrn <- xml2::xml_children(x)
    nms <- xml2::xml_name(chldrn, )
    vals <- xml2::xml_text(chldrn)
    names(vals) <- nms
    res <- data.frame(as.list(vals))
    return(res)
  }
  is_nested <- any(xml2::xml_length(xml2::xml_children(xml)) > 0)
  if (is_nested) {
    chldrn <- xml2::xml_children(xml)
    lst <- lapply(chldrn, node2df)
    res <- do.call("rbind", lst)
  } else {
    res <- node2df(xml)
  }
  return(res)
}
