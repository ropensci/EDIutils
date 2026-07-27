## Release Summary
This EDIutils release, version 3.0.0, transitions all API wrapper functions to 
support mandatory authenticated access using EDI API keys. To minimize the 
impact on downstream workflows, authentication requires minimal updates: users 
simply need to set their API key as an environment variable or pass it directly 
into the login() function.


## Test environments
* aarch64-apple-darwin20, (local machine), R 4.6.0
* aarch64-apple-darwin20 (R-hub), R Under development (unstable) (2026-06-24 r90190)
* x86_64-w64-mingw32 (R-hub), R Under development (unstable) (2026-07-26 r90304 ucrt)
* x86_64-w64-mingw32 (R-hub), R version 4.6.1 (2026-06-24 ucrt)
* x86_64-w64-mingw32 (R-hub), R version 4.5.3 (2026-03-11 ucrt)
* x86_64-pc-linux-gnu Ubuntu (R-hub), R development (unstable) (2026-07-26 r90304)
* x86_64-pc-linux-gnu Ubuntu (R-hub), R version 4.6.1 RC (2026-06-18 r90185)
* x86_64-pc-linux-gnu Ubuntu (R-hub), R version 4.6.1 (2026-06-24)


## R CMD check results
0 ERROR | 0 WARNINGS | 0 NOTES

## Downstream dependencies
There are currently no downstream dependencies for this package.

Thanks!
