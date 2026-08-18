EDIutils 3.0.1 (2026-08-18)
===========================

### MINOR IMPROVEMENTS

  * Migrated the test suite and VCR cassette fixtures to the PASTA staging environment (`https://pasta-s.lternet.edu`), preventing test pollution on the production repository.
  * Enhanced entity and descendant tests to dynamically resolve entity IDs and derived package identifiers at runtime.
  * Added configurable request throttling (`EDI_TEST_THROTTLE_DELAY`, default 2s in CI) for live HTTP test requests to prevent HTTP 429 rate limit errors.
  * Configured VCR cassette mocks for `read_data_package_archive()`.
  * Refactored test-only helper functions into `tests/testthat/helper-test-package.R` to keep package runtime namespace clean and modular.
  * Updated GitHub Actions CI workflows with sequential execution (`max-parallel: 1`), request throttling, and `workflow_dispatch` manual triggers.


EDIutils 3.0.0 (2026-07-27)
===========================

### BREAKING CHANGES

  * Transitioned all API wrapper functions to support mandatory authenticated access using EDI-API keys. Direct `httr` request verbs are now centralized through internal wrappers (`api_get()`, `api_post()`, `api_put()`, `api_delete()`) that append the API key as a query parameter (`?key=`) when the environment variable `EDI_API_KEY` is present.

### MINOR IMPROVEMENTS

  * Updated `login()` to support API key authentication via a new `key` parameter, credentials configuration file, or interactive console prompt.
  * Updated `logout()` to unset the `EDI_API_KEY` environment variable.
  * Enhanced `skip_if_logged_out()` to support running authenticated tests with the `EDI_API_KEY`, while skipping computationally heavy tests unless the environment variable `RUN_ALL_TESTS` is explicitly set to `"true"`.
  * Updated package vignettes and `README.Rmd` documentation with API key authentication details and usage examples.


EDIutils 2.1.0 (2026-05-05)
===========================

### MINOR IMPROVEMENTS

  * Gracefully handle deprecation of the `auth-token`


EDIutils 2.0.0 (2026-01-09)
===========================

### DEPRECATED AND DEFUNCT
  * Deprecate `get_audit_report()` in favor of `get_audit_csv_report()` (#62)
  * Defunct `create_dn()`. This introduces a breaking change for 
    `list_principal_owner_citations()` and `list_user_data_packages()`, 
    which now require an EDI-ID instead of a Distinguished Name (DN). Users can 
    obtain their EDI-ID by logging into the 
    [EDI Identity and Access Manager](https://auth.edirepository.org/auth/ui/signin) 
    and copying the "EDI-ID" from their profile home page. (#65)

### MINOR IMPROVEMENTS

  * Update authentication to support new EDI IAM system (#60)

EDIutils 1.0.3 (2023-10-10)
===========================

### MINOR IMPROVEMENTS

  * Demonstrate retrieval of newest data package version (#46)
  * Update EDI contact email (#51)

### BUG FIXES

  * Fix `read_data_package_archive()` from calling a deprecated endpoint (#47)

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
