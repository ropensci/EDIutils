## Revision
This release fixes a deprecated endpoint in the EDI API and fixes outdated 
documentation.


## Test environments
* aarch64-apple-darwin20, (local machine), R 4.2.2
* x86_64-w64-mingw32 (R-hub), R-devel (2023-07-21 r84722 ucrt)
* x86_64-w64-mingw32 (R-hub), R 4.3.1 (2023-06-16 ucrt)
* x86_64-w64-mingw32 (R-hub), R 4.2.3 (2023-03-15 ucrt)
* x86_64-pc-linux-gnu Ubuntu (R-hub), R-devel (2023-06-09 r84528)
* x86_64-pc-linux-gnu Fedora (R-hub), R-devel (2023-06-09 r84528)
* x86_64-pc-linux-gnu Debian (R-hub), 4.2.2 Patched (2022-11-10 r83330)
* x86_64-pc-linux-gnu Ubuntu (R-hub), 4.3.0 (2023-04-21)


## R CMD check results
0 ERROR | 0 WARNINGS | 3 NOTES

### NOTES

```
 #> * checking for non-standard things in the check directory ... NOTE
 #> Found the following files/directories:
 #> ''NULL''
```
This note appears to be an issue with the R-hub platform. This note occurs on:

* x86_64-w64-mingw32 (R-hub), R-devel (2023-07-21 r84722 ucrt)
* x86_64-w64-mingw32 (R-hub), R 4.3.1 (2023-06-16 ucrt)
* x86_64-w64-mingw32 (R-hub), R 4.2.3 (2023-03-15 ucrt)

```
 #> * checking for detritus in the temp directory ... NOTE
 #> Found the following files/directories:
 #> 'lastMiKTeXException'
```
This note is a recognized bug on R-hub test platforms (for more 
see [here](https://github.com/r-hub/rhub/issues/560)). This note occurs on:

* x86_64-w64-mingw32 (R-hub), R-devel (2023-07-21 r84722 ucrt)
* x86_64-w64-mingw32 (R-hub), R 4.3.1 (2023-06-16 ucrt)
* x86_64-w64-mingw32 (R-hub), R 4.2.3 (2023-03-15 ucrt)
  
```
#> * checking HTML version of manual ... NOTE
#> Skipping checking HTML validation: no command 'tidy' found
```
This note appears to be an issue with the R-hub test platform. This note occurs 
on:

* x86_64-pc-linux-gnu Fedora (R-hub), R-devel (2023-06-09 r84528)
* x86_64-pc-linux-gnu Ubuntu (R-hub), 4.3.0 (2023-04-21)
* x86_64-pc-linux-gnu Ubuntu (R-hub), R-devel (2023-06-09 r84528)


## Downstream dependencies
There are currently no downstream dependencies for this package.

Thank you!
