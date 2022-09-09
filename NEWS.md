EDIutils 1.0.2 (2022-09-05)
===========================

### BUG FIXES
  
  * Fixed failing CRAN check originating from resource outages in the EDI data 
  repository

EDIutils 1.0.1 (2022-06-28)
===========================

### BUG FIXES
  
  * Fixed character encoding bug in the `vcr` dependency


EDIutils 1.0.0 (2022-06-01)
===========================

EDIutils is now on CRAN

EDIutils 0.0.0.9004 (2022-05-17)
================================

### BUG FIXES

  * Fixed parsing bug in `read_data_entity_names()` (#38)

EDIutils 0.0.0.9003 (2022-04-23)
================================

### MAJOR IMPROVEMENTS

  * Completed implementation of reviewer recommendations (version 0.0.0.9002 was incomplete). Some suggested changes have been added as project issues and will be incorporated in a future release (see https://github.com/ropensci/software-review/issues/498#issuecomment-1064787189)

EDIutils 0.0.0.9002 (2022-03-09)
================================

### MAJOR IMPROVEMENTS

* Implemented reviewer recommendations (see https://github.com/ropensci/software-review/issues/498)

EDIutils 0.0.0.9001 (2022-01-20)
================================

### MAJOR IMPROVEMENTS

  * Implement rOpenSci http testing recommendations. Based on https://books.ropensci.org/http-testing/index.html
    * Use vcr to mock http requests
    * Run tests with real http requests via GitHub Actions on a monthly 
    schedule and on push and pull requests to the main branch
    * Update code coverage badge on the main branch when tests use real http requests
    * Precompute all examples and vignettes

EDIutils 0.0.0.9000 (2022-01-10)
================================

### MAJOR IMPROVEMENTS

  * EDIutils has undergone a major refactor for submission to rOpenSci and CRAN. This new and improved version covers the full data repository REST API, handles authentication more securely, better matches API call and result syntax, improves documentation, and opens the door for development of wrapper functions to support common data management tasks. 
  
### DEPRECATED AND DEFUNCT  

  * In the process of this refactor the function names and call patterns have changed and several functions supporting other EDI R packages have been removed, thereby creating back compatibility breaking changes with the previous major release (version 1.6.1). The previous version will be available until 2022-06-01 on the `deprecated` branch. Install the previous version with:

  ```
  remotes::install_github("ropensci/EDIutils", ref = "deprecated")
  ```
