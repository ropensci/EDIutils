
<!-- README.md is generated from README.Rmd. Please edit that file -->

# EDIutils

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![R-CMD-check](https://github.com/EDIorg/EDIutils/workflows/R-CMD-check/badge.svg)](https://github.com/EDIorg/EDIutils/actions)
[![codecov.io](https://codecov.io/gh/EDIorg/EDIutils/branch/master/graph/badge.svg)](https://codecov.io/github/EDIorg/EDIutils?branch=master)
<!-- badges: end -->

*NOTE: Previous version of EDIutils …*

A client for the Environmental Data Initiative repository REST API. The
[EDI data repository](https://portal.edirepository.org/nis/home.jsp) is
for publication and reuse of ecological data with emphasis on metadata
accuracy and richness. It is built upon the [PASTA+ software
stack](https://pastaplus-core.readthedocs.io/en/latest/index.html#) and
was developed in collaboration with the [US LTER
Network](https://lternet.edu/). EDIutils includes functions to search
and access existing data, evaluate and upload new data, and assist other
data management tasks common to repository users.

-   [Search and Access Data]()
-   [Evaluate and Upload Data]()
-   [Retrieve Download Metrics]()
-   [Retrieve Citation Metrics]()

## Installation

Get the latest development version:

``` r
# Requires the remotes package
install.packages("remotes")
remotes::install_github("EDIorg/EDIutils")
library(EDIutils)
```

## Getting Started

The unit of publication is the data package. It’s an assemblage of [EML
metadata](https://eml.ecoinformatics.org/), one or more data objects,
and includes a quality report describing metadata accuracy and
completeness, and a manifest listing package contents. Data packages are
immutable to facilitate reproducible research, and are versionable to
allow updates and improved data quality through time. Each version is
referenceable with a unique DOI. Data package identifiers have the
format “scope.identifier.revision” (e.g. edi.100.1, knb-lter-sbc.20.5),
where “scope” defines the organizational unit, “identifier” is the
package series, and “revision” is the version number.

### Search and Access Data

#### Search

The repository search service is a standard deployment of Apache Solr
and indexes select metadata fields from all data packages for search
purposes.

``` r
# Search for data packages containing the term "water temperature"
res <- search_data_packages(query = 'q="water+temperature"&fl=*')
res
#> {xml_document}
#> <resultset numFound="768" start="0" rows="10">
#>  [1] <document>\n  <abstract>This data set contains water leve ...
#>  [2] <document>\n  <abstract>This data set contains water leve ...
#>  [3] <document>\n  <abstract>The second instrumented buoy on S ...
#>  [4] <document>\n  <abstract>Water temperature was measured on ...
#>  [5] <document>\n  <abstract>Profiles of water and sediment te ...
#>  [6] <document>\n  <abstract>Time series at 5 minute intervals ...
#>  [7] <document>\n  <abstract>Time series at 5 minute intervals ...
#>  [8] <document>\n  <abstract>Time series at 5 minute intervals ...
#>  [9] <document>\n  <abstract>As part of the Long Term Ecologic ...
#> [10] <document>\n  <abstract>Year 2016, continuous measurement ...
```

For a list of searchable fields and more about constructing Solr queries
see `?search_data_packages()`. Users preferring an browser based
experience can use the [advanced search
interface](https://portal.edirepository.org/nis/advancedSearch.jsp) of
the EDI data portal.

#### Access

Data objects are downloaded in raw bytes and parsed by the user
according to data format.

``` r
# List data entities in edi.1047.1
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

# Read raw bytes of Steelhead.csv
raw <- read_data_entity(packageId = "edi.1047.1", entityId = res$entityId[4])
head(raw)
#> [1] ef bb bf 44 61 74

# Parse with .csv reader
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

#### Create EML

Evaluation and upload to the EDI repository requires EML metadata
describing one or more data entities. according to the requirements of
the congruence checker. EDI supports 2 tools that meet these
requirements the EMLassemblyline R package and the ezEML web form based
tool. EML can be created in other ways, but must meet the minimal set of
standards for a data package.

#### Authenticate

Authentication is required by functions involving data evaluation and
upload.

``` r
# Authenticate
login()
#> User name: "my_name"
#> User password: "my_secret"
```

A temporary (\~10 hour) authentication token is written to the system
variable “EDI\_TOKEN” and accessed by EDIutils functions. Programmatic
authentication can be achieved in other ways (see `?login` for details).
Account requests can be made to
<support@environmentaldatainitiative.org>.

#### Evaluate

Evaluation runs a suite of checks for completeness and how well the
metadata describe the target data objects. The data must be web
accessible via links in the EML. See `?evaluate_data_package()` for more
details. Evaluate against the “staging” environment.

``` r
# Evaluate data package
transaction <- evaluate_data_package(
 eml = "./data/edi.595.1.xml", 
 env = "staging")
transaction
#> [1] "evaluate_163966785813042760"

# Check evaluation status
status <- check_status_evaluate(transaction, env = "staging")
status
#> [1] TRUE

# Read evaluation report
report <- read_evaluate_report(transaction, env = "staging")
report
#> {xml_document}
#> <qualityReport schemaLocation="eml://ecoinformatics.org/qualityReport ...
#> [1] <creationDate>2021-12-15T17:46:33</creationDate>
#> [2] <packageId>edi.595.1</packageId>
#> [3] <includeSystem>lter</includeSystem>
#> [4] <includeSystem>knb</includeSystem>
#> [5] <datasetReport>\n  <qualityCheck qualityType="metadata" system=" ...
#> [6] <entityReport>\n  <entityName>data.txt</entityName>\n  <qualityC ...

# Summarize evaluation report
read_evaluate_report_summary(transaction, env = "staging")
#> ===================================================
#>   EVALUATION REPORT
#> ===================================================
#>   
#> PackageId: edi.595.1
#> Report Date/Time: 2021-12-15T17:46:33
#> Total Quality Checks: 29
#> Valid: 21
#> Info: 8
#> Warn: 0
#> Error: 0
```

#### Upload

Upload after all checks resulting in errors have passed. Upload to
staging first to check content rendering, make adjustments, finalize.

``` r
# Create data package
transaction <- create_data_package(
 eml = "./data/edi.595.1.xml", 
 env = "staging")
transaction
#> [1] "create_163966765080210573__edi.595.1"

# Check creation status
status <- check_status_create(
 transaction = transaction, 
 env = "staging")
status
#> [1] TRUE
```

If everything looks good then publish to production. Updating a data
package works the same way but through `update_data_package()`.

## Getting help

Use [GitHub Issues](https://github.com/EDIorg/EDIutils/issues) for bug
reporting, feature requests, and general questions/discussions. When
filing bug reports, please include a minimal reproducible example.

## Contributing

Community contributions are welcome! Please reference our [contributing
guidelines](https://github.com/EDIorg/EDIutils/blob/master/CONTRIBUTING.md)
for details.

------------------------------------------------------------------------

Please note that this package is released with a [Contributor Code of
Conduct](https://ropensci.org/code-of-conduct/). By contributing to this
project, you agree to abide by its terms.
