#' Search Data Packages
#'
#' @description Searches data packages in PASTA using the specified Solr query as the query parameters in the URL. Search results are returned as XML. Detailed examples of Solr queries and their corresponding search results XML are shown below.
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
#' @return Search results are returned in XML format. (See examples below.)
#'     
#' @details GET : https://pasta.lternet.edu/package/search/eml
#' 
#' Solr queries are demonstrated in the examples below.
#' 
#' Note: A full discussion of Solr query syntax is beyond the scope of this document. Documentation on this topic can be found online, for example, the Apache Solr Wiki.
#' 
#' Searchable Fields:
#' 
#' Documents in PASTA’s Solr repository can be discovered based on metadata values stored in the following list of searchable fields: Single-value Fields:
#' Single-value Fields:
#'  abstract
#'  - begindate
#'  - doi
#'  - enddate
#'  - funding
#'  - geographicdescription
#'  - id
#'  - methods
#'  - packageid
#'  - pubdate
#'  - responsibleParties
#'  - scope
#'  - singledate
#'  - site
#'  - taxonomic
#'  - title
#'  Multi-value Fields
#'  - author
#'  - coordinates
#'  - keyword
#'  - organization
#'  - projectTitle
#'  - relatedProjectTitle
#'  - timescale
#'
#' @export
#' 
#' @examples 
#' # Using curl to query PASTA for all documents containing the term "Vernberg", excluding documents with scope "ecotrends" (fq=-scope:ecotrends) and also excluding documents with a scope that begins with the substring "lter-landsat" (fq=-scope:lter-landsat*). In this example, all fields for matching documents are included in the search results (fl=*)
#' 
#' Using curl to query PASTA for all documents with scope “knb-lter-nwt” containing the terms “plant” and “nitrogen” as keywords, and limiting the returned fields to the “packageid”, “doi”, and “keyword” fields and only the first two matches (rows=2). Note that because the keyword field is a multi-value field, its elements are nested inside a parent keywords element.:
#' 
#' Using curl to query PASTA for all documents containing the term “sediment” in the title or the term “disturbance” in the keyword field (q=title:sediment+OR+keyword:disturbance) and limiting the returned fields to the packageid and keyword (fl=packageid,keyword) with up to 1000 matches (rows=1000). Note that because the keyword field is a multi-value field, its elements are nested inside a parent keywords element.
#'
search_data_packages <- function(path, package.id, environment, user.id, user.pass,
                       affiliation){

  # TODO implement
  
  validate_arguments(x = as.list(environment()))

  # Place request
  r <- httr::POST(
    url = paste0(url_env(environment), '.lternet.edu/package/eml'),
    config = httr::authenticate(auth_key(user.id, affiliation), user.pass),
    body = httr::upload_file(paste0(path, '/', package.id, '.xml'))
  )

  # Enter polling loop
  if (r$status_code == '202'){
    transaction_id <- httr::content(r, as = 'text', encoding = 'UTF-8')
    while (TRUE){
      Sys.sleep(2)
      r <- httr::GET(
        url = paste0(url_env(environment), '.lternet.edu/package/error/eml/',
                     transaction_id),
        config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
      )
      if (r$status_code == '200'){
        r_content <- httr::content(r, type = 'text', encoding = 'UTF-8')
        stop(r_content)
        break
      }
      r <- httr::GET(
        url = paste0(url_env(environment), '.lternet.edu/package/eml/',
                     stringr::str_replace_all(package.id, '\\.', '/')),
        config = httr::authenticate(auth_key(user.id, affiliation), user.pass)
      )
      if (r$status_code == '200'){
        eval_report <- readr::read_file(
          paste0(url_env(environment), '.lternet.edu/package/report/eml/',
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
          'Report: ', paste0(url_env(environment),
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
