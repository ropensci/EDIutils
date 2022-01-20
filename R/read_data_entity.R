#' Read data entity
#'
#' @param packageId (character) Data package identifier
#' @param entityId (character) Data entity identifier
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (raw) Raw bytes (i.e. application/octet-stream) to be parsed by a
#' reader function appropriate for the data type
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Read names and IDs of data entities in package "edi.1047.1"
#' res <- read_data_entity_names(packageId = "edi.1047.1")
#' res
#' #>                           entityId                entityName
#' #> 1 3abac5f99ecc1585879178a355176f6d        Environmentals.csv
#' #> 2 f6bfa89b48ced8292840e53567cbf0c8               ByCatch.csv
#' #> 3 c75642ddccb4301327b4b1a86bdee906               Chinook.csv
#' #> 4 2c9ee86cc3f3ffc729c5f18bfe0a2a1d             Steelhead.csv
#' #> 5 785690848dd20f4910637250cdc96819 TrapEfficiencyRelease.csv
#' #> 6 58b9000439a5671ea7fe13212e889ba5 TrapEfficiencySummary.csv
#' #> 7 86e61c1a501b7dcf0040d10e009bfd87        TrapOperations.csv
#' 
#' # Read raw bytes of the 3rd data entity
#' raw <- read_data_entity(packageId = "edi.1047.1", entityId = res$entityId[3])
#' head(raw)
#' #> [1] ef bb bf 44 61 74
#' 
#' # Parse with .csv reader
#' data <- readr::read_csv(file = raw)
#' data
#' #> # A tibble: 105,325 x 20
#' #> Date   trapVisitID subSiteName  catchRawID releaseID commonName     n
#' #> <chr>        <dbl> <chr>             <dbl>     <dbl> <chr>      <dbl>
#' #>   1 1/8/2~         330 North Chann~      32409         0 Chinook s~     1
#' #> 2 1/8/2~         330 North Chann~      32412         0 Chinook s~     1
#' #> 3 1/8/2~         330 North Chann~      32410         0 Chinook s~     1
#' #> 4 1/8/2~         330 North Chann~      32408         0 Chinook s~     1
#' #> 5 1/8/2~         330 North Chann~      32406         0 Chinook s~     1
#' #> 6 1/8/2~         322 North Chann~      31958         0 Chinook s~     1
#' #> 7 1/8/2~         322 North Chann~      31975         0 Chinook s~     1
#' #> 8 1/8/2~         322 North Chann~      31974         0 Chinook s~     1
#' #> 9 1/8/2~         322 North Chann~      31973         0 Chinook s~     1
#' #> 10 1/8/2~         322 North Chann~      31972         0 Chinook s~     1
#' #> # ... with 105,315 more rows, and 13 more variables:
#' #> #   atCaptureRun <chr>, finalRun <chr>, finalRunMethod <chr>,
#' #> #   lifeStage <chr>, forkLength <dbl>, weight <dbl>, mort <chr>,
#' #> #   fishOrigin <chr>, markType <chr>, CatchRaw.comments <chr>,
#' #> #   specimenTypeID <dbl>, physicalSpecimenCode <chr>,
#' #> #   Specimen.comments <lgl>
#' }
read_data_entity <- function(packageId, entityId, env = "production") {
  url <- paste0(
    base_url(env), "/package/data/eml/",
    paste(parse_packageId(packageId), collapse = "/"), "/",
    entityId
  )
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  if (resp$status_code == "200") {
    res <- httr::content(resp, as = "raw", encoding = "UTF-8")
  } else {
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
  }
  return(res)
}
