
<!-- README.md is generated from README.Rmd. Please edit that file -->

# EDIutils

<!-- badges: start -->

[![Project Status: WIP – Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
[![R-CMD-check](https://github.com/EDIorg/EDIutils/workflows/R-CMD-check/badge.svg)](https://github.com/EDIorg/EDIutils/actions)
[![codecov.io](https://codecov.io/gh/EDIorg/EDIutils/branch/master/graph/badge.svg)](https://codecov.io/github/EDIorg/EDIutils?branch=master)
<!-- badges: end -->

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
# Search for data packages containing the term "air temperature"
search_data_packages(query = 'q="air+temperature"&fl=*')
```

For a list of searchable fields and more about constructing Solr queries
see `?search_data_packages()`. Users preferring an browser based
experience can use the [advanced search
interface](https://portal.edirepository.org/nis/advancedSearch.jsp) of
the EDI data portal.

#### Access

Data objects are downloaded in raw bytes and parsed by the user
according to data type.

``` r
# List data entities for .csv files in the data package edi.933.1
entityId <- list_data_entities(packageId = "edi.993.1")
entityId

# Read raw bytes
raw <- read_data_entity(packageId = "edi.993.1", entityId = entityId)
head(raw)

# Parse with .csv reader
data <- readr::read_csv(file = raw)
data
```

### Evaluate and Upload Data

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
authentication can be achieved in 2 other ways (see `?login` for
details). Account requests can be made to
<support@environmentaldatainitiative.org>.

-   create EML
-   simple evaluation
-   simple upload

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
