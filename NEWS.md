# EDIutils 0.0.0.9000

EDIutils has undergone a major refactor for submission to rOpenSci and CRAN. This new and improved version covers the full data repository REST API, handles authentication more securely, better matches API call and result syntax, improves documentation, and opens the door for development of wrapper functions to support common data management tasks. In the process of this refactor the function names and call patterns have changed and several functions supporting other EDI R packages have been removed, thereby creating back compatibility breaking changes with the previous major release (version 1.6.1). The previous version will be available until 2022-06-01 on the `deprecated` branch. Install the previous version with:

```
remotes::install_github("EDIorg/EDIutils", ref = "deprecated")
```
