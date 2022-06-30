#' Publish a "Staged" EDI Data Package 
#' 
#' @description This function accesses a data package from the EDI Staging Environment, assigns a new identifier, and publishes to the EDI Data Portal.
#' 
#' @details User can provide their own identifier or else an identifier will be automatically reserved and assigned.
#'
#' @param staged_id
#'     (character) The full package identifier (scope, accession, revision) of an EDI Data Package in the PASTA staging environment
#' @param prod_id
#'     (character; optional) The full package identifier (scope, accession, revision) of a reserved EDI Data Package that the stage package should be 
#' @param tweet_text
#'     (character; optional) The text for a tweet about the recent data publication. If provided, a URL for a pre-populated tweet (with EDI and the data package both tagged) is returned.     
#'
#' @return transaction (character) Transaction identifier. May be used in a subsequent call to:
#' \itemize{
#'   \item \code{check_status_create()} to determine the operation status
#'   \item \code{read_data_package()} to obtain the data package resource map
#' }
#' 
#' @examples
#' 
#' \dontrun{
#' 
#' # Upload staged package edi.101.1 to the next available edi-scoped, production id:
#' 
#' publish_staged('edi.101.1')
#' 
#' # Upload staged packaged edi.101.1 to a user-specified id:
#' 
#' publish_staged('edi.101.1', 'knb-lter-ntl.5.22')
#' 
#' # Upload staged package edi.101.1 and generate a URL for a pre-populated tweet:
#'  
#'  publish_staged('edi.101.1', tweet_text = "See our recent data package publication!")
#' 
#' }
#'
#' @export
#'
publish_staged <- function(staged_id = NULL, prod_id = NULL, tweet_text = NULL) {
  
  if (is.null(staged_id)) stop("Please provide an EML identifier for a package in the Staging Environment")
  
  # Read staged EML
  
  x <- read_metadata(packageId = staged_id, env = 'staging')
  
  # test for evil symbol
  
  if (isTRUE(grepl('�', x))) stop('The � symbol has been detected! Remove the � before publishing to production!')
  
  # Get user credentials
  
  login()
  
  
  if (is.null(prod_id)) {
    
    # if no prod_id, reserve and assign the next available production id
    
    res_id <- EDIutils::create_reservation('edi')
    
    new_id <- paste0('edi.', res_id, '.1')
    
  } else {
    
    new_id <- prod_id
    
  }
  
  # insert new_id into EML file
  
  xml2::xml_attr(x, 'packageId') <- new_id
  
  # remove dataset/alternateIdentifier
  
  xml2::xml_remove(xml2::xml_find_first(x, 'dataset/alternateIdentifier'))
  
  # delete dataset/distribution
  
  xml2::xml_remove(xml2::xml_find_first(x, 'dataset/distribution'))
  
  # Define full (temporary) path to file
  
  path <- paste0(tempdir(), '/', new_id, '.xml')
  
  # write revised EML to a temporary directory (rename with new_id)
  
  xml2::write_xml(x, path)
  
  # Create data package in production
  if (as.integer(unlist(strsplit(basename(new_id), "\\."))[3]) > 1) {
    
    transaction <- update_data_package(path)
    
    message(paste0("Congratulations! Your data package ", new_id, " has been revised."))
  }else {
    
    transaction <- create_data_package(path)
    
    message(paste0("Congratulations! Your data package ", new_id, " is published."))
    
  }
  
  # print complete message
  
  message(paste0("View your data package at https://portal.edirepository.org/nis/mapbrowse?scope=", unlist(strsplit(basename(new_id), "\\."))[1], "&identifier=", unlist(strsplit(basename(new_id), "\\."))[2]))
  
  if (!is.null(tweet_text)) {
    tweet_url <- template_tweet(packageId = new_id, text = tweet_text)
    
    message(paste0("\n\n\nHere is the URL for your publication's tweet: ", tweet_url))
  }
  
  # TODO if package citations exist
  
  if (data_package_citation_exists(staged_id)) {
    
    message(paste0("\n\nRun this function (once publication is live) to transfer data package citations:\n\n`transfer_journal_citations(\"", staged_id, "\", \"", new_id, "\")`"))
  }
  
  return(transaction)
}





#' Check if the staged package has linked journal citations
#'
#' @param staged_id
#'     (character) The full package identifier (scope, accession, revision) of an EDI Data Package in the PASTA staging environment
#' @param all_versions 
#'     (boolean) If true, checks all revisions of the staged package. If false, only checks the specified revision
#'
#' @return \code{TRUE} if the staged package has a linked journal citation, \code{FALSE} if not.
#' 
#' @examples
#'
#' # Check if staged data package edi.101.1 has a linked journal citation
#' 
#' data_pacakge_citation_exists('edi.101.1')
#' 
#' @export
#' 
data_package_citation_exists <- function(staged_id, all_versions = T) {

  # Handle the all_versions situation
  if (isTRUE(all_versions)) {

    id_stem <- paste0(parse_packageId(staged_id)$scope, '.', parse_packageId(staged_id)$id)
    id_rev <- parse_packageId(staged_id)$rev
    
    r <- seq.int(as.numeric(id_rev))
    x <- lapply(r, function(rev) {
      list_data_package_citations(paste0(id_stem, '.', rev), env = 'staging', as = 'xml')
    })
    
    x <- lapply(x, function(element) {
        if (length(xml2::xml_find_all(element, './/journalCitationId')) > 0) return(TRUE)
      })
    
    if(is.null(unlist(x))) return(FALSE)

    return(unlist(x))
    
  } else {  
    
    x <- list_data_package_citations(staged_id, env = 'staging')
    if (length(xml2::xml_find_all(x, './/journalCitationId')) > 0) return(TRUE)
    return(FALSE)
  }
  
  
}






#' Transfer linked journal citations from a staged data package to a published data package
#'
#' @param staged_id
#'     (character) The full package identifier (scope, accession, revision) of an EDI Data Package in the PASTA staging environment
#' @param prod_id
#'     (character; optional) The full package identifier (scope, accession, revision) of a reserved EDI Data Package that the stage package should be 
#' @param all_versions
#'     (boolean) If true, checks all revisions of the staged package. If false, only checks the specified revision
#'
#' @return The linked journal citations from the staged data package are now linked to the published data package
#'
#' @examples
#' 
#' # Transfer journal citations from staged package edi.101.1 to published data package edi.787.1
#' 
#' transfer_journal_citations('edi.101.1', 'edi.787.1', all_versions = T)
#' 
#' # Transfer journal citations from all versions of staged package edi.101 to published data package edi.787.1
#' 
#' transfer_journal_citations('edi.101.6', 'edi.787.1', all_versions = T)
#' 
#' @export
#' 
transfer_journal_citations <- function(staged_id, new_id, all_versions = T) {
  
  if (isTRUE(all_versions)) {
    
    id_stem <- paste0(parse_packageId(staged_id)$scope, '.', parse_packageId(staged_id)$id)
    id_rev <- parse_packageId(staged_id)$rev
    
    r <- seq.int(as.numeric(id_rev))
    x <- lapply(r, function(rev) {
      list_data_package_citations(paste0(id_stem, '.', rev), env = 'staging')
    })
    
    cids <- lapply(
      x, function(element) {
        unlist(xml2::as_list(xml2::xml_find_all(element, './/journalCitationId')))
      } 
    )
    
    cids <- unlist(cids)
  } else {
    
    cids <- unlist(xml2::as_list(xml2::xml_find_all(list_data_package_citations(staged_id, env = 'staging'), './/journalCitationId')))
  }
  
  lapply(cids,
         function(x) {
           # Get citation from staging
           # jid <- xml2::xml_text(xml2::xml_find_all(x, './/journalCitationId'))
           citation <- get_journal_citation(x, env = 'staging')
           doi <- xml2::xml_text(xml2::xml_find_all(citation, './/articleDoi'))
           article <- xml2::xml_text(xml2::xml_find_all(citation, './/articleTitle'))
           a_url <- xml2::xml_text(xml2::xml_find_all(citation, './/articleUrl'))
           journal <- xml2::xml_text(xml2::xml_find_all(citation, './/journalTitle'))
           relation <- xml2::xml_text(xml2::xml_find_all(citation, './/relationType'))
           # Publish citation to production
           create_journal_citation(
             packageId = new_id,
             articleDoi = doi,
             articleUrl = a_url,
             articleTitle = article,
             journalTitle = journal,
             relationType = relation,
             env = 'production')
         })
  
  message(paste0("Journal citation transfered. View your data package at https://portal.edirepository.org/nis/mapbrowse?scope=", unlist(strsplit(basename(new_id), "\\."))[1], "&identifier=", unlist(strsplit(basename(new_id), "\\."))[2]))
} 


