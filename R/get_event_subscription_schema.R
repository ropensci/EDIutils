#' Get event subscription schema
#'
#' @param env (character) Repository environment. Can be: "production",
#' "staging", or "development".
#'
#' @return (xml_document) Schema for event subscription creation request
#' entities.
#' 
#' See the 
#' \href{https://CRAN.R-project.org/package=xml2}{xml2} library 
#' for more on working with XML.
#' 
#' @family Event Notifications
#'
#' @export
#'
#' @examples
#' \dontrun{
#' 
#' # Get schema
#' schema <- get_event_subscription_schema()
#' schema
#' #> {xml_document}
#' #> <schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
#' #> [1] <xs:element name="subscription">\n  <xs:complexType>\n    <xs:    ...
#' 
#' # Show schema structure
#' xml2::xml_structure(schema)
#' #> <schema [xmlns:xs]>
#' #>   <element [name]>
#' #>     <complexType>
#' #>       <all>
#' #>         <element [name, type, minOccurs, maxOccurs]>
#' #>         <element [name, type, minOccurs, maxOccurs]>
#' #>       <attribute [name, type, use, fixed]>
#' }
get_event_subscription_schema <- function(env = "production") {
  url <- paste0(base_url(env), "/package/event/eml/schema")
  resp <- httr::GET(url, set_user_agent(), handle = httr::handle(""))
  res <- httr::content(resp, as = "text", encoding = "UTF-8")
  httr::stop_for_status(resp, res)
  return(xml2::read_xml(res))
}
