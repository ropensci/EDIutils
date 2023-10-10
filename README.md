
<!-- README.md is generated from README.Rmd. Please edit that file -->

# EDIutils

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check](https://github.com/ropensci/EDIutils/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/EDIutils/actions)
[![Status at rOpenSci Software Peer
Review](https://badges.ropensci.org/498_status.svg)](https://github.com/ropensci/software-review/issues/498)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/EDIutils)](https://cran.r-project.org/package=EDIutils)
[![codecov.io](https://codecov.io/gh/ropensci/EDIutils/branch/main/graph/badge.svg)](https://app.codecov.io/github/ropensci/EDIutils?branch=main)
[![DOI](https://zenodo.org/badge/159572464.svg)](https://zenodo.org/badge/latestdoi/159572464)

<!-- badges: end -->

A client for the Environmental Data Initiative repository REST API. The
[EDI data repository](https://portal.edirepository.org/nis/home.jsp) is
for publication and reuse of ecological data with emphasis on metadata
accuracy and completeness. It was developed in collaboration with the
[US LTER Network](https://lternet.edu/) and is built upon the [PASTA+
software
stack](https://pastaplus-core.readthedocs.io/en/latest/index.html#).
EDIutils includes functions to search and access existing data, evaluate
and upload new data, and assist with related data management tasks.

- [Search and Access
  Data](https://docs.ropensci.org/EDIutils/articles/search_and_access.html)
- [Evaluate and Upload
  Data](https://docs.ropensci.org/EDIutils/articles/evaluate_and_upload.html)
- [Retrieve Download
  Metrics](https://docs.ropensci.org/EDIutils/articles/retrieve_downloads.html)
- [Retrieve Citation
  Metrics](https://docs.ropensci.org/EDIutils/articles/retrieve_citations.html)

## Installation

Get the latest version:

``` r
install.packages("EDIutils")
```

Get the development version:

``` r
remotes::install_github("ropensci/EDIutils", ref = "development")
```

## Getting Started

``` r
library(EDIutils)
```

The unit of publication is the data package. It contains one or more
data entities (i.e. files) described with [EML
metadata](https://eml.ecoinformatics.org/), a metadata quality report,
and a manifest of package contents. Data packages are immutable for
reproducible research, yet versionable to allow updates and improved
data quality through time. Each version is assigned a DOI and a unique
package ID of the form “scope.identifier.revision”. The “scope” is the
organizational unit, “identifier” the series, and “revision” the version
(e.g. “edi.100.2” is version “2” of data package “edi.100”).

### Authentication

Authentication is required by data evaluation and upload functions, and
to access user audit logs and services. Contact EDI for an account
<support@edirepository.org>. Authenticate with the `login()` function.

### Search and Access Data

The repository search service is a standard deployment of Apache Solr
and indexes select metadata fields of data package metadata. For a list
of searchable fields see `search_data_packages()`. For a browser based
search experience, use the [EDI data
portal](https://portal.edirepository.org/nis/advancedSearch.jsp).

``` r
# List data packages containing the term "water temperature"
res <- search_data_packages(query = 'q="water+temperature"&fl=*')
colnames(res)
#>  [1] "abstract"              "begindate"             "doi"                  
#>  [4] "enddate"               "funding"               "geographicdescription"
#>  [7] "id"                    "methods"               "packageid"            
#> [10] "pubdate"               "responsibleParties"    "scope"                
#> [13] "site"                  "taxonomic"             "title"                
#> [16] "authors"               "spatialCoverage"       "sources"              
#> [19] "keywords"              "organizations"         "singledates"          
#> [22] "timescales"

nrow(res)
#> [1] 798
```

Data entities are downloaded in raw bytes and parsed by a reader
function.

``` r
# List data entities of data package edi.1047.1
res <- read_data_entity_names(packageId = "edi.1047.1")
res
#>                           entityId                entityName
#> 1 3abac5f99ecc1585879178a355176f6d        Environmentals.csv
#> 2 f6bfa89b48ced8292840e53567cbf0c8               ByCatch.csv
#> 3 c75642ddccb4301327b4b1a86bdee906               Chinook.csv
#> 4 2c9ee86cc3f3ffc729c5f18bfe0a2a1d             Steelhead.csv
#> 5 785690848dd20f4910637250cdc96819 TrapEfficiencyRelease.csv
#> 6 58b9000439a5671ea7fe13212e889ba5 TrapEfficiencySummary.csv
#> 7 86e61c1a501b7dcf0040d10e009bfd87        TrapOperations.csv

# Read raw bytes of Steelhead.csv (i.e. the 4th data entity)
raw <- read_data_entity(packageId = "edi.1047.1", entityId = res$entityId[4])
head(raw)
#> [1] ef bb bf 44 61 74

# Parse with a .csv reader
data <- readr::read_csv(file = raw)
data
#> # A tibble: 2,926 x 14
#>    Date   trapVisitID subSiteName catchRawID releaseID commonName 
#>    <chr>        <dbl> <chr>            <dbl>     <dbl> <chr>      
#>  1 1/12/~         326 North Chan~      32123         0 Steelhead ~
#>  2 1/14/~         336 North Chan~      33980         0 Steelhead ~
#>  3 1/15/~         337 North Chan~      32683         0 Steelhead ~
#>  4 1/16/~         339 North Chan~      32971         0 Steelhead ~
#>  5 1/17/~         341 North Chan~      33104         0 Steelhead ~
#>  6 1/18/~         342 North Chan~      33304         0 Steelhead ~
#>  7 1/19/~         343 North Chan~      33432         0 Steelhead ~
#>  8 1/21/~         349 North Chan~      34083         0 Steelhead ~
#>  9 1/21/~         349 North Chan~      34084         0 Steelhead ~
#> 10 1/23/~         351 North Chan~      34384         0 Steelhead ~
#> # ... with 2,916 more rows, and 8 more variables:
#> #   lifeStage <chr>, forkLength <dbl>, weight <dbl>, n <dbl>,
#> #   mort <chr>, fishOrigin <chr>, markType <chr>,
#> #   CatchRaw.comments <chr>
```

### Evaluate and Upload Data

The EDI data repository has a
“[staging](https://portal-s.edirepository.org/nis/home.jsp)” environment
to test the upload and rendering of new data packages before publishing
to “[production](https://portal.edirepository.org/nis/home.jsp)”.
Authentication is required by functions involving data evaluation and
upload. Request an account from <support@edirepository.org>.

``` r
# Authenticate
login()
#> User name: "my_name"
#> User password: "my_secret"
```

Data package reservations prevent conflicting use of the same
identifier.

``` r
# Reserve a data package identifier
identifier <- create_reservation(scope = "edi", env = "staging")
identifier
#> [1] 595
```

Evaluation checks for metadata accuracy and completeness.

``` r

# Evaluate data package
transaction <- evaluate_data_package(
 eml = paste0(tempdir(), "/edi.595.1.xml"), 
 env = "staging")
transaction
#> [1] "evaluate_163966785813042760"

# Check status
status <- check_status_evaluate(transaction, env = "staging")
status
#> [1] TRUE

# Read the evaluation report
report <- read_evaluate_report(transaction, as = "char", env = "staging")
message(report)
#> ===================================================
#>   EVALUATION REPORT
#> ===================================================
#>   
#> PackageId: edi.595.1
#> Report Date/Time: 2021-12-16T08:17:40
#> Total Quality Checks: 29
#> Valid: 21
#> Info: 8
#> Warn: 0
#> Error: 0
#> 
#> ---------------------------------------------------
#>   DATASET REPORT
#> ---------------------------------------------------
#>   
#> IDENTIFIER: packageIdPattern
#> NAME: packageId pattern matches "scope.identifier.revision"
#> DESCRIPTION: Check against LTER requirements for scope.identifier.revision
#> EXPECTED: 'scope.n.m', where 'n' and 'm' are integers and 'scope' is one ...
#> FOUND: edi.595.1
#> STATUS: valid
#> EXPLANATION: 
#> SUGGESTION: 
#> REFERENCE: 
#> 
#> IDENTIFIER: emlVersion
#> NAME: EML version 2.1.0 or beyond
#> DESCRIPTION: Check the EML document declaration for version 2.1.0 or higher
#> EXPECTED: eml://ecoinformatics.org/eml-2.1.0 or higher
#> FOUND: https://eml.ecoinformatics.org/eml-2.2.0
#> STATUS: valid
#> EXPLANATION: Validity of this quality report is dependent on this check ...
#> SUGGESTION: 
#> REFERENCE: 
#> ...
```

Upload after errors and warnings are fixed.

``` r
# Create a new data package
transaction <- create_data_package(
 eml = paste0(tempdir(), "/edi.595.1.xml"), 
 env = "staging")
transaction
#> [1] "create_163966765080210573__edi.595.1"

# Check status
status <- check_status_create(
 transaction = transaction, 
 env = "staging")
status
#> [1] TRUE
```

Once everything looks good in the “staging” environment, then repeat the
above reservation and upload steps in the “production” environment where
the data package will be assigned a DOI and made discoverable with other
published data.

## Getting help

Use [GitHub Issues](https://github.com/ropensci/EDIutils/issues) for bug
reporting, feature requests, and general questions/discussions. When
filing bug reports, please include a minimal reproducible example.

## Contributing

Community contributions are welcome! Please reference our [contributing
guidelines](https://github.com/ropensci/EDIutils/blob/master/CONTRIBUTING.md)
for details.

------------------------------------------------------------------------

Please note that this package is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By contributing to this
project, you agree to abide by its terms.
