#' List service methods
#'
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character) A simple list of web service methods supported by the
#' Data Package Manager web service
#' 
#' @family Listing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # All service methods
#' services <- list_service_methods()
#' services
#' #>  [1] "appendProvenance"              "createDataPackage"            
#' #>  [3] "createDataPackageArchive"      "createReservation"            
#' #>  [5] "deleteReservation"             "deleteDataPackage"            
#' #>  [7] "evaluateDataPackage"           "getProvenanceMetadata"        
#' #>  [9] "isAuthorized"                  "listActiveReservations"       
#' #> [11] "listDataEntities"              "listDataDescendants"          
#' #> [13] "listDataSources"               "listRecentChanges"            
#' #> [15] "listDataPackageIdentifiers"    "listDataPackageRevisions"     
#' #> [17] "listDataPackageScopes"         "listDeletedDataPackages"      
#' #> [19] "listRecentUploads"             "listReservationIdentifiers"   
#' #> [21] "listServiceMethods"            "listUserDataPackages"         
#' #> [23] "listWorkingOn"                 "readDataEntity"               
#' #> [25] "readDataEntityAcl"             "readDataEntityRmd"            
#' #> [27] "readDataEntityChecksum"        "readDataEntityDoi"            
#' #> [29] "readDataEntityName"            "readDataEntityNames"          
#' #> [31] "readDataEntitySize"            "readDataEntitySizes"          
#' #> [33] "readDataPackage"               "readDataPackageAcl"           
#' #> [35] "readDataPackageRmd"            "readDataPackageArchive"       
#' #> [37] "readDataPackageDoi"            "readDataPackageError"         
#' #> [39] "readDataPackageFromDoi"        "readDataPackageReport"        
#' #> [41] "readDataPackageReportAcl"      "readDataPackageReportRmd"     
#' #> [43] "readDataPackageReportChecksum" "readDataPackageReportDoi"     
#' #> [45] "readEvaluateReport"            "readMetadata"                 
#' #> [47] "readMetadataDublinCore"        "readMetadataAcl"              
#' #> [49] "readMetadataRmd"               "readMetadataChecksum"         
#' #> [51] "readMetadataDoi"               "readMetadataFormat"           
#' #> [53] "searchDataPackages"            "updateDataPackage"            
#' #> [55] "createSubscription"            "deleteSubscription"           
#' #> [57] "executeSubscription"           "getMatchingSubscriptions"     
#' #> [59] "getSubscriptionWithId"         "notifyOfEvent"                
#' #> [61] "createJournalCitation"         "deleteJournalCitation"        
#' #> [63] "getCitationWithId"             "listDataPackageCitations"     
#' #> [65] "listPrincipalOwnerCitations"  
#' }
list_service_methods <- function(env = "production") {
  url <- paste0(base_url(env), "/package/service-methods")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(text2char(res))
}
