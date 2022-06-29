## Revision
This release fixes failing CRAN Checks resulting from the 'vcr' dependency.


## Test environments
* local Windows install, R 4.1.0
* x86_64-w64-mingw32 (64-bit), (R-hub builder), R 4.0.5 (2021-03-31)
* x86_64-w64-mingw32 (64-bit), (R-hub builder), R 4.1.2 (2021-11-01)
* x86_64-w64-mingw32 (64-bit), (R-hub builder), R-dev (2022-06-22 r82512 ucrt)
* x86_64-apple-darwin17.0 (64-bit), (R-hub builder), R 4.1.1 (2021-08-10)
* aarch64-apple-darwin20 (64-bit), (R-hub builder), R 4.1.3 (2022-03-10)
* x86_64-pc-linux-gnu (64-bit), (R-hub builder), R 4.2.0 (2022-04-22)
* x86_64-pc-linux-gnu (64-bit), (R-hub builder), R 4.2.1 (2022-06-23)
* x86_64-pc-linux-gnu (64-bit), (R-hub builder), R-dev (2022-06-27 r82528)


## R CMD check results
0 ERROR | 0 WARNINGS | 1 NOTES

* checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
  'lastMiKTeXException'

  This note occurs in one test environment (Windows, R-hub, R-devel (2022-06-22 r82512 ucrt)) and appears to be related to configuration of the virtual machine.

## Downstream dependencies
There are currently no downstream dependencies for this package

Cheers!
