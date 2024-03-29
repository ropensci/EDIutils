% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query_event_subscriptions.R
\name{query_event_subscriptions}
\alias{query_event_subscriptions}
\title{Query event subscriptions}
\usage{
query_event_subscriptions(query = NULL, as = "data.frame", env = "production")
}
\arguments{
\item{query}{(character) Query (see details below)}

\item{as}{(character) Format of the returned object. Can be: "data.frame" 
or "xml".}

\item{env}{(character) Repository environment. Can be: "production",
"staging", or "development".}
}
\value{
(data.frame or xml_document) A list of the subscriptions whose 
attributes match those specified in the query string (see details below). 
If a query string is omitted, all subscriptions in the subscription database 
will be returned for which the requesting user is authorized to read. If 
query parameters are included, they are used to filter that set of 
subscriptions based on their attributes.
}
\description{
Query event subscriptions
}
\details{
Query parameters are specified as key=value pairs, multiple pairs
must be delimited with ampersands (&), and only a single value should be
specified for a particular key. The following query parameter keys are
allowed:

\itemize{
  \item creator
  \item scope
  \item identifier
  \item revision
  \item url
}

If a query parameter is specified, and a subscription's respective attribute
does not match it, that subscription will not be included in the group of
subscriptions returned. If scope, identifier, or revision are used, their
values must together constitute a syntactically and semantically correct EML
packageId (i.e. "scope.identifier.revision") - either partial or complete.
If url is used, its value must not contain ampersands. Therefore, if a
subscription's URL contains ampersands, it cannot be filtered based on its
URL.
}
\note{
User authentication is required (see \code{login()})
}
\examples{
\dontrun{

login()

# Query subscriptions
query <- "scope=edi"
subscriptions <- query_event_subscriptions(query, env = "staging")

logout()
}

}
\seealso{
Other Event Notifications: 
\code{\link{create_event_subscription}()},
\code{\link{delete_event_subscription}()},
\code{\link{execute_event_subscription}()},
\code{\link{get_event_subscription_schema}()},
\code{\link{get_event_subscription}()}
}
\concept{Event Notifications}
