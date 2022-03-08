#' Read data package citation
#'
#' @param packageId (character) Data package identifier
#' @param access (logical) Return a datestamp in the citation of the current 
#' UTC date. This is recommended by the ESIP citation style guide.
#' @param style (character) Set the style for which to format the citation. Can
#' be: "ESIP", "DRYAD", "BIBTEX", "RAW".
#' @param ignore (character) Ignore individuals, organizations, or positions in 
#' the author list. Can be: "INDIVIDUALS", "ORGANIZATIONS", or "POSITIONS". See 
#' details below.
#' @param as (character) Format of the returned citation. Can be: "char", 
#' "html", "json".
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (character or html_document or json) The data package citation
#'
#' @details A citation may consist of a list of authors, publication year, 
#' title, data package version, publisher, digital object identifier, and 
#' access date. The order and presence of these components depends on the 
#' \code{style} requested for the citation (see query parameters above).
#' 
#' A brief discussion of the fields in a citation:
#' \itemize{
#'   \item Authors - This function uses content extracted from the science 
#'   metadata described by an Ecological Metadata Language (EML) document to 
#'   generate the author list. Specifically, it uses the creator section of EML 
#'   to generate the list of authors, including individuals, organizations, and 
#'   positions.
#'   
#'   This function preserves the order of the creator list as defined within 
#'   the EML document. As such, if you would like the citation to begin with an 
#'   organization name, you should position the creator element that describes 
#'   the organization at the beginning of the creator list in the EML document.
#'   
#'   This function also assumes that a creator element contains information 
#'   pertaining to only a single "creator", although EML allows for multiple 
#'   identities in a single creator element. It will do its best to 
#'   accommodate multi-named subjects within a creator element, but mileage 
#'   will vary.
#'   
#'   This function is opinionated in how it determines an author: individuals, 
#'   take precedence over organizations and positions, and organizations take 
#'   precedence over positions. What this means is if an individual and 
#'   organization and position are all defined in a single creator element, 
#'   this function sets the author to the named information within the 
#'   individual element; and, if only an organization and position exist within 
#'   a single creator element, this function will set the author to the named 
#'   information within the organization element. Finally, if only a position 
#'   is defined within a single creator element, this function will set the 
#'   author to the named information within the position element. It is 
#'   important to note that this function respects the creator content as 
#'   defined in the EML document and will set a position name to an author if 
#'   it is present and meets the above hierarchy. If you believe that a 
#'   position should not be displayed as data package author, then you should 
#'   not include it as a data package creator.
#'   
#'   Finally, this function does not collect or use tertiary information (e.g., 
#'   phone number, addresses, emails) from within the creator element since 
#'   this type of information is not used as part of a data package citation.
#'   
#'   \item Publication Year - The publication year is defined by the calendar 
#'   year when the data package was archived into the EDI data repository. The 
#'   publication year may differ from the year of the publication date entered 
#'   into the EML, which is often set to the date when the data package became 
#'   publicly available, although not yet archived into the EDI data 
#'   repository.
#'   
#'   \item Title - This function uses the title section of EML as the citation 
#'   title. EML title elements are copied verbatim into the citation.
#'   
#'   \item Version Number - The citation version number represents the revision 
#'   step (or increment) of the data package as archived in the EDI data 
#'   repository. Revision values are whole numbers and have a one-to-one 
#'   correspondence to the revision of the data package in the repository.
#'   
#'   \item Publisher - By default, the publisher field of the citation is 
#'   permanently set to "Environmental Data Initiative". This value will not 
#'   change during the tenure of the EDI data repository.
#'   
#'   \item DOI - The Digital Object Identifier (DOI) is the EDI generated DOI 
#'   value that is registered with DataCite, and is displayed using the fully 
#'   qualified "doi.org" URL. This DOI URL will resolve to the corresponding 
#'   "landing page" of the data package as displayed on the EDI Data Portal.
#'   
#'   \item Access Date - The access date is the UTC date in which the citation 
#'   was requested.
#' }
#' 
#' @family Accessing
#'
#' @export
#'
#' @examples
#' \dontrun{
#'
#' packageId <- "edi.460.1"
#' 
#' # Retrieve "ESIP" stylized citation (default) in plain text format
#' citation <- read_data_package_citation(packageId)
#' citation
#' #> [1] "Armitage, A.R., C.A. Weaver, J.S. Kominoski, and S.C. Pennings. ..."
#' 
#' # Retrieve "DRYAD" stylized citation in plain text format
#' citation <- read_data_package_citation(packageId, style = "DRYAD")
#' citation
#' #> [1] "Armitage AR, Weaver CA, Kominoski JS, and Pennings SC (2020) Hur..."
#' 
#' # Retrieve "ESIP" stylized citation (default) in HTML format
#' citation <- read_data_package_citation(packageId, as = "html")
#' citation
#' #> {html_document}
#' #> <html>
#' #> [1] <body><p>Armitage, A.R., C.A. Weaver, J.S. Kominoski, and S.C. Pen...
#' 
#' # Retrieve "ESIP" stylized citation (default), ignoring individuals, in 
#' # plain text format
#' citation <- read_data_package_citation(packageId, ignore = "INDIVIDUALS")
#' citation
#' #> [1] "Texas A&M University at Galveston, Texas A&M University - Corpu ..."
#' }
#'
read_data_package_citation <- function(packageId,
                                       access = TRUE,
                                       style = "ESIP",
                                       ignore = NULL,
                                       as = "char",
                                       env = "production") {
  # Build query
  url <- paste0("https://cite.edirepository.org/cite/", packageId, "?")
  url <- paste0(url, "env=", env)
  url <- paste0(url, "&style=", style)
  if (!is.null(ignore)) {
    url <- paste0(url, "&ignore=", ignore)
  }
  if (isTRUE(access)) {
    url <- paste0(url, "&access")
  }
  # Place request
  if (as == "char") {
    resp <- httr::GET(
      url,
      set_user_agent(),
      httr::accept("text/plain"),
      handle = httr::handle("")
    )
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(res)
  } else if (as == "html") {
    resp <- httr::GET(
      url,
      set_user_agent(),
      httr::accept("text/html"),
      handle = httr::handle("")
    )
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(xml2::read_html(res))
  } else if (as == "json") {
    resp <- httr::GET(
      url,
      set_user_agent(),
      httr::accept("application/json"),
      handle = httr::handle("")
    )
    res <- httr::content(resp, as = "text", encoding = "UTF-8")
    httr::stop_for_status(resp, res)
    return(jsonlite::toJSON(res))
  }
}
