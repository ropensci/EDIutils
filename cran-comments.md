## New submission
## Resubmission
This is a resubmission. In this version I have:

* Ensured package names, software names and API (application programming 
interface) names are enclosed in single quotes in the title and description.

* Added a description of the return value for a function that was missing this
information.

* Ensured functions do not write to the user's home filespace in examples, 
vignettes, and tests.

## Test environments
* local Windows install, R 4.1.0
* x86_64-w64-mingw32 (64-bit), (R-hub builder), R 4.0.5 (2021-03-31)
* x86_64-w64-mingw32 (64-bit), (R-hub builder), R 4.1.2 (2021-11-01)
* x86_64-w64-mingw32 (64-bit), (R-hub builder), R-dev (2022-03-23 r81968 ucrt)
* x86_64-apple-darwin17.0 (64-bit), (R-hub builder), R 4.1.1 (2021-08-10)
* aarch64-apple-darwin20 (64-bit), (R-hub builder), R 4.1.3 (2022-03-10)
* x86_64-pc-linux-gnu (64-bit), (R-hub builder), R 4.2.0 (2022-04-22)
* x86_64-pc-linux-gnu (64-bit), (R-hub builder), R-dev (2022-05-23 r82396)


## R CMD check results
0 ERROR | 0 WARNINGS | 3 NOTES

* New submission

* Possibly misspelled words in DESCRIPTION:
  EDI (9:86)
  EDIutils (9:444)
  LTER (9:407)
  
  These are not a misspelled words. These are acronyms and the package name.
  
* checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
  'lastMiKTeXException'

  This note occurs in one test environment (Windows, R-hub, R-devel (2022-03-23 r81968 ucrt)) and appears to be related to the virtual machine configuration.

## Downstream dependencies
There are currently no downstream dependencies for this package

Many thanks!
